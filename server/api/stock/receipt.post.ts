import { createError, readBody } from 'h3'
import { prisma } from '~/server/utils/db'

type ReceiptTransaction = Omit<
  typeof prisma,
  '$connect' | '$disconnect' | '$on' | '$transaction' | '$use' | '$extends'
>

async function handleCardThresholdNotification(
  tx: ReceiptTransaction,
  counterName: string,
  threshold: number,
  quantity: number,
  messageFactory: (amount: number) => string
) {
  await tx.$executeRaw`
    INSERT INTO "stock_threshold_counters" ("product_name", "current_count", "threshold", "updated_at")
    VALUES (${counterName}, 0, ${threshold}, NOW())
    ON CONFLICT ("product_name") DO NOTHING
  `

  const [counter] = await tx.$queryRaw<Array<{ current_count: number; threshold: number }>>`
    SELECT "current_count", "threshold"
    FROM "stock_threshold_counters"
    WHERE "product_name" = ${counterName}
    FOR UPDATE
  `

  if (!counter) {
    throw createError({ statusCode: 500, statusMessage: 'Stock threshold counter not found' })
  }

  const total = counter.current_count + quantity
  const notificationsCount = Math.floor(total / counter.threshold)
  const remainder = total % counter.threshold

  await tx.$executeRaw`
    UPDATE "stock_threshold_counters"
    SET
      "current_count" = ${remainder},
      "updated_at" = NOW()
    WHERE "product_name" = ${counterName}
  `

  if (notificationsCount > 0) {
    await tx.$executeRaw`
      INSERT INTO "admin_notifications" ("message", "is_read", "created_at")
      VALUES (${messageFactory(notificationsCount * counter.threshold)}, false, NOW())
    `
  }
}

export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }
  if (!user.is_super) {
    throw createError({ statusCode: 403, statusMessage: 'Forbidden: super admin only' })
  }

  const body = await readBody(event)
  const productId = Number(body?.productId)
  const quantity = Number(body?.quantity)
  const note = typeof body?.note === 'string' ? body.note.trim() : ''

  if (!Number.isInteger(productId) || productId <= 0) {
    throw createError({ statusCode: 400, statusMessage: 'productId is required' })
  }

  if (!Number.isInteger(quantity) || quantity <= 0) {
    throw createError({ statusCode: 400, statusMessage: 'quantity must be a positive integer' })
  }

  const result = await prisma.$transaction(async (tx) => {
    const product = await tx.products.findUnique({
      where: { id: productId },
      select: { id: true, name: true, quantity: true, isAvailable: true }
    })

    if (!product) {
      throw createError({ statusCode: 404, statusMessage: 'Product not found' })
    }

    const updated = await tx.products.update({
      where: { id: productId },
      data: {
        quantity: product.quantity + quantity,
        isAvailable: product.quantity + quantity > 0 ? true : product.isAvailable,
        updated_at: new Date()
      },
      select: {
        id: true,
        quantity: true
      }
    })

    await tx.stock_movements.create({
      data: {
        product_id: productId,
        quantity,
        type: 'receipt',
        note: note || null,
        created_by: user.username || null
      }
    })

    if (product.name === 'Карта') {
      await handleCardThresholdNotification(
        tx,
        'Карта',
        1000,
        quantity,
        (amount) => `Получено ${amount} карт. Нужно заказать чистящее устройство.`
      )

      await handleCardThresholdNotification(
        tx,
        'Карта: лента для принтера',
        135,
        quantity,
        (amount) => `Получено ${amount} карт. Нужно купить ${amount / 135} лент для принтера.`
      )
    }

    return updated
  })

  return { ok: true, product: result }
})
