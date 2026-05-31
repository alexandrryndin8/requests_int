<template>
  <section class="w-full max-w-6xl mx-auto px-3 sm:px-4 space-y-5">
    <div v-if="notifications.length" class="rounded-xl border border-amber-200 bg-amber-50 p-4 shadow-sm space-y-3">
      <div>
        <h3 class="text-base font-semibold text-amber-950">Уведомления</h3>
      </div>

      <article
        v-for="notification in notifications"
        :key="notification.id"
        class="flex flex-col gap-3 rounded-lg border border-amber-200 bg-white px-3 py-3 sm:flex-row sm:items-center sm:justify-between"
      >
        <div>
          <p class="text-sm font-medium text-slate-900">{{ notification.message }}</p>
          <p class="mt-1 text-xs text-slate-500">{{ formatDateTime(notification.created_at) }}</p>
        </div>
        <button
          type="button"
          class="shrink-0 rounded border border-amber-300 px-3 py-2 text-sm font-semibold text-amber-900 transition hover:bg-amber-100"
          @click="markNotificationRead(notification.id)"
        >
          Прочитано
        </button>
      </article>
    </div>

    <div class="rounded-xl border bg-white p-4 shadow-sm space-y-4">
      <div>
        <h3 class="text-base font-semibold">Приход на склад</h3>
        <p class="text-sm text-gray-500">Выберите устройство и укажите количество для прихода.</p>
      </div>

      <p v-if="error" class="text-sm text-red-600">{{ error }}</p>
      <p v-if="success" class="text-sm text-green-600">{{ success }}</p>

      <form class="grid grid-cols-1 md:grid-cols-[1fr_1fr_0.7fr_1fr_auto] gap-3 items-end" @submit.prevent="submitReceipt">
        <div>
          <label class="block text-sm mb-1">Устройство</label>
          <select v-model="receiptProductName" class="w-full border rounded px-3 py-2 text-sm">
            <option value="">Выберите устройство</option>
            <option v-for="name in receiptDeviceOptions" :key="name" :value="name">
              {{ name }}
            </option>
          </select>
        </div>

        <div v-if="receiptRequiresColor">
          <label class="block text-sm mb-1">Цвет браслета</label>
          <select v-model="receiptColor" class="w-full border rounded px-3 py-2 text-sm">
            <option value="">Выберите цвет</option>
            <option v-for="color in braceletColorOptions" :key="color" :value="color">
              {{ color }}
            </option>
          </select>
        </div>
        <div v-else class="hidden md:block"></div>

        <div>
          <label class="block text-sm mb-1">Количество</label>
          <input
            v-model.number="receiptQuantity"
            type="number"
            min="1"
            class="w-full border rounded px-3 py-2 text-sm"
            placeholder="0"
          />
        </div>

        <div>
          <label class="block text-sm mb-1">Комментарий</label>
          <input
            v-model="receiptNote"
            type="text"
            class="w-full border rounded px-3 py-2 text-sm"
            placeholder="Например: приход со склада"
          />
        </div>

        <button
          type="submit"
          class="border rounded px-4 py-2 text-sm font-semibold bg-gray-900 text-white hover:bg-gray-800"
        >
          Добавить
        </button>
      </form>
    </div>

    <div class="rounded-xl border bg-white p-4 shadow-sm space-y-4">
      <div class="flex items-center justify-between gap-3">
        <div>
          <h3 class="text-base font-semibold">Остатки</h3>
          <p class="text-sm text-gray-500">Красным подсвечиваются позиции, где осталось меньше 100 штук.</p>
        </div>
        <button class="border rounded px-3 py-2 text-sm" @click="load">Обновить</button>
      </div>

      <div class="hidden sm:block overflow-x-auto">
        <table class="min-w-full text-sm border">
          <thead class="bg-gray-100">
            <tr>
              <th class="p-2 border text-left">Устройство</th>
              <th class="p-2 border text-left">Цвет</th>
              <th class="p-2 border text-left">Цена</th>
              <th class="p-2 border text-left">Остаток</th>
              <th class="p-2 border text-left">Обновлено</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="product in products" :key="product.id" :class="product.isLowStock ? 'bg-red-50' : ''">
              <td class="p-2 border">{{ product.name }}</td>
              <td class="p-2 border">{{ product.color || '—' }}</td>
              <td class="p-2 border">{{ formatMoney(product.price) }}</td>
              <td class="p-2 border">
                <span :class="product.isLowStock ? 'font-semibold text-red-600' : 'text-gray-900'">
                  {{ product.quantity }}
                </span>
              </td>
              <td class="p-2 border whitespace-nowrap">{{ formatDateTime(product.updated_at) }}</td>
            </tr>
            <tr v-if="products.length === 0">
              <td colspan="5" class="p-3 text-center text-gray-500">Устройств пока нет</td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="sm:hidden space-y-3">
        <article
          v-for="product in products"
          :key="'mobile-' + product.id"
          class="rounded-lg border p-4"
          :class="product.isLowStock ? 'bg-red-50 border-red-200' : 'bg-white'"
        >
          <p class="text-sm"><strong>Устройство:</strong> {{ product.name }}</p>
          <p class="text-sm mt-1"><strong>Цвет:</strong> {{ product.color || '—' }}</p>
          <p class="text-sm mt-1"><strong>Цена:</strong> {{ formatMoney(product.price) }}</p>
          <p class="text-sm mt-1">
            <strong>Остаток:</strong>
            <span :class="product.isLowStock ? 'font-semibold text-red-600' : 'text-gray-900'">
              {{ product.quantity }}
            </span>
          </p>
          <p class="text-sm mt-1"><strong>Обновлено:</strong> {{ formatDateTime(product.updated_at) }}</p>
        </article>
      </div>
    </div>

    <div class="rounded-xl border bg-white p-4 shadow-sm space-y-4">
      <div>
        <h3 class="text-base font-semibold">Последние движения</h3>
        <p class="text-sm text-gray-500">История приходов и автоматических списаний.</p>
      </div>

      <div class="overflow-x-auto">
        <table class="min-w-full text-sm border">
          <thead class="bg-gray-100">
            <tr>
              <th class="p-2 border text-left">Дата</th>
              <th class="p-2 border text-left">Устройство</th>
              <th class="p-2 border text-left">Тип</th>
              <th class="p-2 border text-left">Количество</th>
              <th class="p-2 border text-left">Оператор</th>
              <th class="p-2 border text-left">Комментарий</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="movement in recentMovements" :key="movement.id">
              <td class="p-2 border whitespace-nowrap">{{ formatDateTime(movement.created_at) }}</td>
              <td class="p-2 border">{{ movement.productLabel }}</td>
              <td class="p-2 border">{{ movementTypeLabel(movement.type) }}</td>
              <td class="p-2 border">
                <span :class="movement.quantity < 0 ? 'text-red-600 font-semibold' : 'text-green-700 font-semibold'">
                  {{ movement.quantity > 0 ? `+${movement.quantity}` : movement.quantity }}
                </span>
              </td>
              <td class="p-2 border">{{ movement.created_by || 'system' }}</td>
              <td class="p-2 border">{{ movement.note || '—' }}</td>
            </tr>
            <tr v-if="recentMovements.length === 0">
              <td colspan="6" class="p-3 text-center text-gray-500">Движений пока нет</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>
</template>

<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'

type StockProduct = {
  id: number
  code: string
  name: string
  color: string | null
  price: number
  quantity: number
  updated_at: string
  isLowStock: boolean
}

type StockMovement = {
  id: number
  quantity: number
  type: string
  note: string | null
  created_by: string | null
  created_at: string
  productLabel: string
}

type AdminNotification = {
  id: number
  message: string
  created_at: string
}

const products = ref<StockProduct[]>([])
const recentMovements = ref<StockMovement[]>([])
const notifications = ref<AdminNotification[]>([])
const receiptProductName = ref('')
const receiptColor = ref('')
const receiptQuantity = ref<number | null>(null)
const receiptNote = ref('')
const error = ref('')
const success = ref('')

const receiptDeviceOptions = computed(() =>
  [...new Set(products.value.map((product) => product.name))].sort((a, b) => a.localeCompare(b, 'ru'))
)

const braceletColorOptions = computed(() =>
  products.value
    .filter((product) => product.name === 'Браслет' && product.color && product.color !== 'Все цвета')
    .map((product) => product.color as string)
    .sort((a, b) => a.localeCompare(b, 'ru'))
)

const receiptRequiresColor = computed(() => receiptProductName.value === 'Браслет')

const receiptProductId = computed(() => {
  const product = products.value.find((item) => {
    if (item.name !== receiptProductName.value) return false
    if (receiptRequiresColor.value) return item.color === receiptColor.value
    return !item.color
  })

  return product?.id ?? null
})

watch(receiptProductName, (value) => {
  if (value !== 'Браслет') {
    receiptColor.value = ''
    return
  }

  if (!braceletColorOptions.value.includes(receiptColor.value)) {
    receiptColor.value = braceletColorOptions.value[0] || ''
  }
})

async function load() {
  error.value = ''
  try {
    const response = await $fetch<{ products: StockProduct[]; recentMovements: StockMovement[] }>('/api/stock')
    products.value = response.products
    recentMovements.value = response.recentMovements
  } catch (e: any) {
    error.value = e?.statusMessage || 'Ошибка загрузки склада'
  }
}

async function loadNotifications() {
  try {
    const response = await $fetch<{ notifications: AdminNotification[] }>('/api/admin-notifications')
    notifications.value = response.notifications
  } catch (e: any) {
    error.value = e?.statusMessage || 'Ошибка загрузки уведомлений'
  }
}

async function markNotificationRead(id: number) {
  error.value = ''
  try {
    await $fetch('/api/admin-notifications/read', {
      method: 'POST',
      body: { id }
    })
    notifications.value = notifications.value.filter((notification) => notification.id !== id)
  } catch (e: any) {
    error.value = e?.statusMessage || 'Ошибка обновления уведомления'
  }
}

async function submitReceipt() {
  error.value = ''
  success.value = ''

  if (!receiptProductId.value) {
    error.value = receiptRequiresColor.value ? 'Выберите устройство и цвет браслета' : 'Выберите устройство'
    return
  }

  if (!receiptQuantity.value || receiptQuantity.value < 1) {
    error.value = 'Укажите корректное количество'
    return
  }

  try {
    await $fetch('/api/stock/receipt', {
      method: 'POST',
      body: {
        productId: Number(receiptProductId.value),
        quantity: Number(receiptQuantity.value),
        note: receiptNote.value
      }
    })

    success.value = 'Приход добавлен'
    receiptProductName.value = ''
    receiptColor.value = ''
    receiptQuantity.value = null
    receiptNote.value = ''
    await load()
    await loadNotifications()
  } catch (e: any) {
    error.value = e?.statusMessage || 'Ошибка сохранения прихода'
  }
}

function formatMoney(value: number) {
  return `${value.toLocaleString('ru-RU')} ₸`
}

function formatDateTime(value: string) {
  return new Date(value).toLocaleString('ru-RU', {
    day: '2-digit',
    month: '2-digit',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

function movementTypeLabel(type: string) {
  if (type === 'receipt') return 'Приход'
  if (type === 'issue') return 'Списание'
  return type
}

onMounted(async () => {
  await load()
  await loadNotifications()
})
</script>
