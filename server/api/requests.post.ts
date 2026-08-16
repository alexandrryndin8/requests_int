import { readBody, createError } from 'h3'
import { prisma } from '~/server/utils/db'
import { normalize, validateNamePart, titleCaseNamePart } from '~/server/utils/validators'
import { enforceRateLimit } from '~/server/utils/rateLimit'

interface RecaptchaResponse {
  success: boolean
  score?: number
  action?: string
  challenge_ts?: string
  hostname?: string
  'error-codes'?: string[]
}

export default defineEventHandler(async (event) => {
  try {
    enforceRateLimit(event, {
      key: 'requests',
      limit: 10,
      windowMs: 5 * 60 * 1000,
      message: 'Слишком много заявок. Попробуйте через несколько минут.'
    })

    const cfg = useRuntimeConfig()
    const body = await readBody(event)

    // ---- reCAPTCHA (как было) ----
    const token = body?.token as string | undefined
    if (!token) throw createError({ statusCode: 400, statusMessage: 'No reCAPTCHA token' })

    const devBypass = process.env.NODE_ENV === 'development' || process.env.RECAPTCHA_BYPASS === '1'
    let res: RecaptchaResponse = { success: true, score: 1 }

    if (!devBypass) {
      const secret = cfg.RECAPTCHA_SECRET_KEY as string
      if (!secret) throw createError({ statusCode: 500, statusMessage: 'reCAPTCHA secret not set' })

      res = await $fetch<RecaptchaResponse>('https://www.google.com/recaptcha/api/siteverify', {
        method: 'POST',
        body: new URLSearchParams({ secret, response: token }),
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
      })
    }

    const minScore = process.env.NODE_ENV === 'production' ? 0.5 : 0.1
    if (!res.success || (res.score ?? 0) < minScore) {
      throw createError({ statusCode: 403, statusMessage: 'reCAPTCHA' })
    }

    // ---- Нормализация и валидация ФИО ----
    const full_name_raw = normalize(String(body.full_name ?? ''))
    const parts = full_name_raw.split(' ').filter(Boolean) // [Фамилия, Имя, (Отчество)?]
    if (parts.length < 2) {
      throw createError({ statusCode: 400, statusMessage: 'Укажите фамилию и имя' })
    }
    const [surname, name, ...rest] = parts
    const patronymic = normalize(rest.join(' '))

    const errSurname = validateNamePart(surname)
    const errName = validateNamePart(name)
    const errPatro = patronymic ? validateNamePart(patronymic) : ''
    if (errSurname || errName || errPatro) {
      throw createError({ statusCode: 400, statusMessage: 'Некорректное ФИО' })
    }

    const surnameT    = titleCaseNamePart(surname)
    const nameT       = titleCaseNamePart(name)
    const patronymicT = patronymic ? titleCaseNamePart(patronymic) : ''

    const full_name   = [surnameT, nameT, patronymicT].filter(Boolean).join(' ')

    // ---- Остальные поля + нормализация ----
    const school = normalize(String(body.school ?? ''))
    const klass  = normalize(String(body.class ?? ''))
    const device = normalize(String(body.device_type ?? ''))

    if (!school || !klass || !device) {
      throw createError({ statusCode: 400, statusMessage: 'Не все поля заполнены' })
    }

    // ---- Проверка на активный дубликат (full_name+school+class, регистронезависимо) ----
    const activeDuplicate = await prisma.requests.findFirst({
      where: {
        deleted: false,
        full_name: { equals: full_name, mode: 'insensitive' },
        school:    { equals: school,    mode: 'insensitive' },
        class:     { equals: klass,     mode: 'insensitive' },
        status:    { in: ['Принято', 'В обработке', 'Готово к выдаче'] }
      },
      select: { id: true }
    })
    if (activeDuplicate) {
      throw createError({
        statusCode: 409,
        statusMessage: 'Ваша заявка уже подана и находится в обработке.'
      })
    }

    // ---- Создание и возврат track_id + password (генерит БД) ----
    const created = await prisma.requests.create({
      data: {
        full_name,
        school,
        class: klass,
        device_type: device,
        source: 'Сайт'
      },
      select: { track_id: true, password: true }
    })

    return { user: { track_id: created.track_id, password: created.password } }

  } catch (error: any) {
    console.error(' API POST /api/requests error!')
    console.error('Error name:', error?.name)
    console.error('Message:', error?.message)
    console.error('Stack:', error?.stack)
    console.error('Cause:', error?.cause)
    if (error?.code) console.error('→ Prisma error code:', error.code)
    if (error?.meta) console.error('→ Prisma meta:', error.meta)

    throw createError({
      statusCode: error.statusCode || 500,
      statusMessage: error.statusMessage || error.message || 'Internal Server Error'
    })
  }
})
