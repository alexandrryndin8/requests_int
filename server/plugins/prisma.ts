import { prisma } from '~/server/utils/db'

export default defineNitroPlugin(() => {
	console.log('prisma initialized')
})
