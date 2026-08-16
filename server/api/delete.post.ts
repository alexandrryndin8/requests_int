// import { PrismaClient } from '@prisma/client'

// const prisma = new PrismaClient()

import { prisma } from '~/server/utils/db'


// Сериализация телеграм айдишника так как он бигинт и просто так не может
function serializeBigInt(obj: any): any {
  return JSON.parse(
    JSON.stringify(obj, (_, value) =>
      typeof value === 'bigint' ? value.toString() : value
    )
  );
}

export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  try {
    const body = await readBody(event)

    const { track_id } = body

    if (!track_id) {
      throw createError({ statusCode: 400, statusMessage: 'track_id не передан' })
    }

    const updated = await prisma.requests.update({
      where: { track_id },
      data: { deleted: true},
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

    return {
      success: true,
      message: 'Запись успешно удалена (помечена как удалённая)',
      request: serializeBigInt(updated)
    }

  } catch (error) {
    console.error('Ошибка при удалении:', error)
    throw createError({
      statusCode: 500,
      statusMessage: 'Ошибка при удалении заявки',
    })
  }
})