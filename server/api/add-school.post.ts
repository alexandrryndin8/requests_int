import { prisma } from '~/server/utils/db'
import { createError } from 'h3'

export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  const body = await readBody(event)

  const newSchool = await prisma.schools.create({
    data: {
      name: body.name,
      type: body.type
    }
  })

  return {
    success: true,
    school: newSchool
  }
})