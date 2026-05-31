import { createError } from 'h3'
import { prisma } from '~/server/utils/db'

export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  const notifications = await prisma.$queryRaw<Array<{
    id: number
    message: string
    created_at: Date
  }>>`
    SELECT "id", "message", "created_at"
    FROM "admin_notifications"
    WHERE "is_read" = false
    ORDER BY "created_at" DESC
    LIMIT 20
  `

  return { notifications }
})
