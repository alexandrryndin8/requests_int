import { prisma } from '~/server/utils/db'
import { getQuery, createError } from 'h3'

type KnownProduct = 'Карта' | 'Браслет' | 'Брелок' | 'Другое'

function normalizeProduct(deviceType: string): KnownProduct {
  const s = (deviceType || '').trim()
  if (s.startsWith('Браслет')) return 'Браслет'
  if (s.startsWith('Карта')) return 'Карта'
  if (s.startsWith('Брелок')) return 'Брелок'
  return 'Другое'
}

function toDateKey(value: Date | null | undefined) {
  if (!value) return ''
  return value.toISOString().slice(0, 10)
}

function buildDateRange(from: Date, to: Date) {
  const result: string[] = []
  const cursor = new Date(from)

  while (cursor <= to) {
    result.push(cursor.toISOString().slice(0, 10))
    cursor.setUTCDate(cursor.getUTCDate() + 1)
  }

  return result
}

export default defineEventHandler(async (event) => {
  const user = (event as any).context.user
  if (!user) {
    throw createError({ statusCode: 401, statusMessage: 'Unauthorized' })
  }

  const q = getQuery(event)
  const from = String(q.from || '')
  const to = String(q.to || '')

  if (!from || !to) {
    throw createError({ statusCode: 400, statusMessage: 'from and to are required (YYYY-MM-DD)' })
  }

  const dateFrom = new Date(`${from}T00:00:00.000Z`)
  const dateTo = new Date(`${to}T23:59:59.999Z`)

  if (Number.isNaN(dateFrom.getTime()) || Number.isNaN(dateTo.getTime())) {
    throw createError({ statusCode: 400, statusMessage: 'Invalid date format' })
  }

  if (dateFrom > dateTo) {
    throw createError({ statusCode: 400, statusMessage: 'from must be before to' })
  }

  const products = await prisma.products.findMany({
    select: { name: true, price: true, updated_at: true }
  })
  const priceByName = new Map<string, { price: number; updated_at: Date }>()

  for (const product of products) {
    const existing = priceByName.get(product.name)
    if (!existing || product.updated_at > existing.updated_at) {
      priceByName.set(product.name, {
        price: product.price,
        updated_at: product.updated_at
      })
    }
  }

  const priceMap = new Map(
    Array.from(priceByName.entries()).map(([name, value]) => [name, value.price])
  )

  const createdRows = await prisma.requests.findMany({
    where: {
      deleted: false,
      created_at: { gte: dateFrom, lte: dateTo }
    },
    select: {
      school: true,
      source: true,
      status: true,
      created_at: true
    }
  })

  const issuedRows = await prisma.requests.findMany({
    where: {
      status: 'Выдан',
      deleted: false,
      status_modified_at: { gte: dateFrom, lte: dateTo }
    },
    select: {
      device_type: true,
      status_modified_at: true
    }
  })

  const statusMap: Record<string, number> = {}
  const schoolMap: Record<string, number> = {}
  const sourceMap: Record<string, number> = {}
  const createdByDayMap: Record<string, number> = {}
  const issuedByDayMap: Record<string, number> = {}
  const productMap: Record<string, { product: string; price: number; count: number; sum: number }> = {}

  for (const row of createdRows) {
    const status = row.status?.trim() || 'Без статуса'
    const school = row.school?.trim() || 'Не указано'
    const source = row.source?.trim() || 'Не указан'
    const day = toDateKey(row.created_at)

    statusMap[status] = (statusMap[status] || 0) + 1
    schoolMap[school] = (schoolMap[school] || 0) + 1
    sourceMap[source] = (sourceMap[source] || 0) + 1
    if (day) createdByDayMap[day] = (createdByDayMap[day] || 0) + 1
  }

  for (const row of issuedRows) {
    const product = normalizeProduct(row.device_type || '')
    const price = priceMap.get(product) ?? 0
    const day = toDateKey(row.status_modified_at)

    if (!productMap[product]) {
      productMap[product] = { product, price, count: 0, sum: 0 }
    }

    productMap[product].count += 1
    productMap[product].sum += price
    if (day) issuedByDayMap[day] = (issuedByDayMap[day] || 0) + 1
  }

  const items = Object.values(productMap)
    .filter((item) => item.count > 0)
    .sort((a, b) => b.count - a.count || a.product.localeCompare(b.product))

  const total = items.reduce((acc, item) => acc + item.sum, 0)
  const createdCount = createdRows.length
  const issuedCount = issuedRows.length
  const conversionRate = createdCount > 0 ? Number(((issuedCount / createdCount) * 100).toFixed(1)) : 0

  const statusItems = Object.entries(statusMap)
    .map(([status, count]) => ({ status, count }))
    .sort((a, b) => b.count - a.count || a.status.localeCompare(b.status))

  const schoolItems = Object.entries(schoolMap)
    .map(([school, count]) => ({ school, count }))
    .sort((a, b) => b.count - a.count || a.school.localeCompare(b.school))
    .slice(0, 10)

  const sourceItems = Object.entries(sourceMap)
    .map(([source, count]) => ({ source, count }))
    .sort((a, b) => b.count - a.count || a.source.localeCompare(b.source))

  const dateKeys = buildDateRange(
    new Date(`${from}T00:00:00.000Z`),
    new Date(`${to}T00:00:00.000Z`)
  )

  const dailyItems = dateKeys.map((date) => ({
    date,
    created: createdByDayMap[date] || 0,
    issued: issuedByDayMap[date] || 0
  }))

  return {
    from,
    to,
    summary: {
      createdCount,
      issuedCount,
      totalRevenue: total,
      conversionRate,
      activeProducts: items.length
    },
    items,
    total,
    statusItems,
    schoolItems,
    sourceItems,
    dailyItems
  }
})
