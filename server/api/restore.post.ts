// server/api/restore.ts
import { prisma } from '~/server/utils/db'

import { defineEventHandler, readBody, createError } from 'h3'


export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  const body = await readBody(event)
  const { track_id } = body

  if (!track_id) {
    return { error: 'track_id обязателен' }
  }

  try {
    const updated = await prisma.requests.updateMany({
      where: {
        track_id,
        deleted: true,
      },
      data: {
        deleted: false,
      },
    })

    if (updated.count === 0) {
      return { message: 'Запись не найдена или уже восстановлена' }
    }

    return { success: true, restored: updated.count }
  } catch (error) {
    console.error('Ошибка восстановления:', error)
    return { error: 'Ошибка при восстановлении записи' }
  }
})
