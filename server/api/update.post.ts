import { prisma } from '~/server/utils/db'
import axios from 'axios'
import dotenv from 'dotenv'
import { resolveProductFromDeviceType } from '~/server/utils/inventory'

dotenv.config()

const botToken = process.env.TELEGRAM_BOT_TOKEN

// Сериализация телеграм айдишника так как он бигинт и просто так не может
function serializeBigInt(obj: any): any {
  return JSON.parse(
    JSON.stringify(obj, (_, value) =>
      typeof value === 'bigint' ? value.toString() : value
    )
  );
}

if (!botToken) {
  throw new Error('TELEGRAM_BOT_TOKEN is not set in .env')
}

export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  const body = await readBody(event)
  const { track_id, status } = body

  if (!track_id || !status) {
    throw createError({ statusCode: 400, statusMessage: 'track_id and status are required' })
  }

  const updated = await prisma.$transaction(async (tx) => {
    const request = await tx.requests.findUnique({
      where: { track_id },
      select: {
        id: true,
        status: true,
        device_type: true,
        telegram_id: true,
        track_id: true,
        school: true,
        class: true,
        created_at: true,
        full_name: true,
        phone: true,
        password: true,
        source: true,
        deleted: true
      }
    })

    if (!request) {
      throw createError({ statusCode: 404, statusMessage: 'Request not found' })
    }

    const shouldDeductStock = request.status !== 'Выдан' && status === 'Выдан'

    if (shouldDeductStock) {
      const resolved = resolveProductFromDeviceType(request.device_type || '')
      const product = await tx.products.findFirst({
        where: {
          name: resolved.name,
          color: resolved.color
            ? { equals: resolved.color, mode: 'insensitive' }
            : null
        },
        select: {
          id: true,
          quantity: true,
          name: true,
          color: true
        }
      })

      if (!product) {
        const message = resolved.color
          ? `Не найден складской остаток для "${resolved.name}" цвета "${resolved.color}"`
          : `Не найден складской остаток для "${resolved.name}"`
        throw createError({ statusCode: 409, statusMessage: message })
      }

      if (product.quantity < 1) {
        const label = product.color ? `${product.name} (${product.color})` : product.name
        throw createError({ statusCode: 409, statusMessage: `Недостаточно остатка: ${label}` })
      }

      await tx.products.update({
        where: { id: product.id },
        data: {
          quantity: product.quantity - 1,
          isAvailable: product.quantity - 1 > 0 ? undefined : false,
          updated_at: new Date()
        }
      })

      await tx.stock_movements.create({
        data: {
          product_id: product.id,
          quantity: -1,
          type: 'issue',
          note: `Выдано по заявке ${track_id}`,
          created_by: 'system'
        }
      })
    }

    return tx.requests.update({
      where: { track_id },
      data: {
        status,
        status_modified_at: new Date()
      },
      select: {
        id: true,
        full_name: true,
        school: true,
        class: true,
        device_type: true,
        track_id: true,
        status: true,
        created_at: true,
        source: true,
        status_modified_at: true,
        phone: true,
        deleted: true,
        telegram_id: true
      }
    })
  })

  const chatId = updated.telegram_id?.toString()
  if (!chatId) {
    return { success: true, updated }
  }

  const deviceType = updated.device_type || 'неизвестно'

  let messageText
  if (status.toLowerCase() === 'выполнен') {
    messageText = `Статус заявки с трек-номером ${track_id} обновлён на "${status}".\nУстройство: ${deviceType}. \nЗабрать с 9:00 до 18:00(обед c 13:00 до 14:00) c пн по пт по адресу: ул. К. Сутюшева 53`
  } else {
    messageText = `Статус заявки с трек-номером ${track_id} обновлён на "${status}".\nУстройство: ${deviceType}`
  }

  try {
    await axios.post(`https://api.telegram.org/bot${botToken}/sendMessage`, {
      chat_id: chatId,
      text: messageText
    })
  } catch (error) {
    console.error('Ошибка отправки уведомления в Telegram:', error)
  }

  return { success: true, updated: serializeBigInt(updated) }
})
