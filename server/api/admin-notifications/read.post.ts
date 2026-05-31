import { createError, readBody } from 'h3'
import { prisma } from '~/server/utils/db'

export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  const body = await readBody(event)
  const id = Number(body?.id)

  if (!Number.isInteger(id) || id <= 0) {
    throw createError({ statusCode: 400, statusMessage: 'id is required' })
  }

  await prisma.$executeRaw`
    UPDATE "admin_notifications"
    SET
      "is_read" = true,
      "read_at" = NOW(),
      "read_by" = ${user.username || null}
    WHERE "id" = ${id}
  `

  return { ok: true }
})
