import { createError } from 'h3'

const buckets = new Map<string, { count: number; windowStart: number }>()

export function enforceRateLimit(
  event: any,
  opts: { key: string; limit: number; windowMs: number; message?: string }
) {
  const ip =
    event.node.req.headers['x-forwarded-for']?.toString().split(',')[0].trim() ||
    event.node.req.socket.remoteAddress ||
    'unknown'

  const bucketKey = `${opts.key}:${ip}`
  const now = Date.now()
  const bucket = buckets.get(bucketKey) || { count: 0, windowStart: now }

  if (now - bucket.windowStart > opts.windowMs) {
    bucket.count = 0
    bucket.windowStart = now
  }

  bucket.count++
  buckets.set(bucketKey, bucket)

  if (bucket.count > opts.limit) {
    throw createError({
      statusCode: 429,
      statusMessage: opts.message || 'Слишком много запросов. Попробуйте позже.'
    })
  }
}
