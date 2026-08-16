import { prisma } from '~/server/utils/db'
import { createError } from 'h3'


export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  const id = Number(getQuery(event).id)

  await prisma.schools.delete({
    where: { id }
  })

  return { success: true }
})