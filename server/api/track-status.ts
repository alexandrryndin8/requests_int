import { prisma } from '~/server/utils/db'
import { enforceRateLimit } from '~/server/utils/rateLimit'
import type { RecaptchaResponse } from '~/server/utils/recaptcha'


export default defineEventHandler(async (event) => {
  enforceRateLimit(event, {
    key: 'track-status',
    limit: 10,
    windowMs: 5 * 60 * 1000,
    message: 'Слишком много попыток проверки статуса. Попробуйте через несколько минут.'
  })

  const body = await readBody(event)
  const { track_id, password, token } = body

  // Валидация ввода
  if (!track_id || !password || !token) {
    throw createError({ statusCode: 400, statusMessage: 'Missing data' })
  }

  // Проверка капчи
  const secretKey = useRuntimeConfig().RECAPTCHA_SECRET_KEY

  const recaptchaRes = await $fetch<RecaptchaResponse>('https://www.google.com/recaptcha/api/siteverify', {
    method: 'POST',
    body: new URLSearchParams({
      secret: secretKey,
      response: token
    }),
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded'
    }
  })

  // Лог для проверки капчи
  console.log('Ответ от reCAPTCHA API:', {
      success: recaptchaRes.success,
      score: recaptchaRes.score,
      action: recaptchaRes.action,
      hostname: recaptchaRes.hostname,
      challenge_ts: recaptchaRes.challenge_ts,
      errorCodes: recaptchaRes['error-codes'] || []
    })

    if (!recaptchaRes.success || (recaptchaRes.score ?? 0) < 0.7) {
      throw createError({ statusCode: 403, statusMessage: 'Не прошел reCAPTCHA' })
    }

    if (recaptchaRes.action !== 'track_request') { 
      throw createError({ statusCode: 403, statusMessage: 'Invalid action' })
    }

  // Поиск заявки
  const request = await prisma.requests.findFirst({
    where: {
      track_id,
      password
    }
  })

  if (!request) {
    throw createError({ statusCode: 404, statusMessage: 'Request not found' })
  }

  return {
    status: request.status
  }
})
