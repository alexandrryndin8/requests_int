import { prisma } from '~/server/utils/db'
import { createError } from 'h3'


export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  const requests = await prisma.requests.findMany({
    where: { deleted: true }, 
    orderBy: { created_at: 'desc' },
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
      phone: true
    }
  })

  return {
    requests
  }
})