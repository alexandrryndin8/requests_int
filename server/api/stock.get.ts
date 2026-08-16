import { createError } from 'h3'
import { prisma } from '~/server/utils/db'
import { formatProductLabel } from '~/server/utils/inventory'

export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }
  if (!user.is_super) {
    throw createError({ statusCode: 403, statusMessage: 'Forbidden: super admin only' })
  }

  const products = await prisma.products.findMany({
    orderBy: [
      { name: 'asc' },
      { color: 'asc' },
      { id: 'asc' }
    ],
    select: {
      id: true,
      code: true,
      name: true,
      color: true,
      price: true,
      quantity: true,
      updated_at: true
    }
  })

  const recentMovements = await prisma.stock_movements.findMany({
    orderBy: { created_at: 'desc' },
    take: 20,
    select: {
      id: true,
      quantity: true,
      type: true,
      note: true,
      created_by: true,
      created_at: true,
      product: {
        select: {
          name: true,
          color: true
        }
      }
    }
  })

  const braceletProducts = products.filter((product) => product.name === 'Браслет' && product.color)
  const braceletAggregateSource = products.find((product) => product.name === 'Браслет' && !product.color)

  const stockProducts = products
    .filter((product) => product.name !== 'Браслет' || Boolean(product.color))
    .map((product) => ({
      ...product,
      label: formatProductLabel(product.name, product.color),
      isLowStock: product.quantity < 100
    }))

  if (braceletAggregateSource && braceletProducts.length > 0) {
    const totalQuantity = braceletProducts.reduce((sum, product) => sum + product.quantity, 0)
    const updatedAt = braceletProducts.reduce(
      (latest, product) => (product.updated_at > latest ? product.updated_at : latest),
      braceletAggregateSource.updated_at
    )

    stockProducts.unshift({
      ...braceletAggregateSource,
      color: 'Все цвета',
      quantity: totalQuantity,
      updated_at: updatedAt,
      label: 'Браслет (Все цвета)',
      isLowStock: totalQuantity < 100
    })
  }

  return {
    products: stockProducts,
    recentMovements: recentMovements.map((movement) => ({
      id: movement.id,
      quantity: movement.quantity,
      type: movement.type,
      note: movement.note,
      created_by: movement.created_by,
      created_at: movement.created_at,
      productLabel: formatProductLabel(movement.product.name, movement.product.color)
    }))
  }
})
