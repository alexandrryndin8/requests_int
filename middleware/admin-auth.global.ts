// middleware/admin-auth.global.ts (SSR-only проверка)
export default defineNuxtRouteMiddleware(async (to) => {
  if (!to.path.startsWith('/admin')) return
  if (!process.server) return

  const config = useRuntimeConfig()
  const { getCookie } = await import('h3')
  const jwt = (await import('jsonwebtoken')).default

  const event = useRequestEvent()
  if (!event) return navigateTo('/login')
  const token = getCookie(event, 'auth')

  if (!token) return navigateTo('/login')
  try {
    jwt.verify(token, config.JWT_SECRET as string)
  } catch {
    return navigateTo('/login')
  }
})
