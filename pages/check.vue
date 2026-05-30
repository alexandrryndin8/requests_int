<template>
  <main class="bg_custom relative z-10 flex min-h-[calc(100vh-5rem)] w-full items-center justify-center px-4 py-6 sm:px-6 lg:py-8">
    <section class="w-full max-w-xl overflow-hidden rounded-sm bg-white shadow-2xl shadow-slate-200/80 ring-1 ring-slate-200/70">
      <header class="px-5 py-7 sm:px-10 sm:py-9">
        <h1 class="text-2xl font-bold tracking-tight text-slate-900 sm:text-3xl">Проверить статус заявки</h1>
        <p class="mt-2 text-sm font-medium text-slate-500">Введите трек-номер и пароль, чтобы узнать текущий статус.</p>
      </header>

      <div class="relative h-px bg-slate-200">
        <div class="absolute left-5 top-0 h-px w-24 bg-[#3FB1F3] sm:left-10"></div>
      </div>

      <div class="space-y-5 px-5 py-6 sm:px-10 sm:py-8">
        <form class="space-y-5" @submit.prevent='trackRequest'>
          <div>
            <label for="track_id" class="mb-2 block text-sm font-semibold text-slate-900">Трек-номер</label>
            <input
              type="text"
              id="track_id"
              placeholder="Введите трек-номер (12 символов)"
              class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
              v-model="track"
              maxlength="12"
            >
          </div>

          <div>
            <label for="password" class="mb-2 block text-sm font-semibold text-slate-900">Пароль</label>
            <input
              type="text"
              id="password"
              placeholder="Введите пароль (8 символов)"
              class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
              v-model="password"
              maxlength="8"
            >
          </div>

          <button class="w-full rounded px-6 py-3 text-sm font-semibold text-white bg-[#3FB1F3] shadow-lg shadow-slate-900/15 transition-transform hover:bg-[#318fc6] active:scale-95" type="submit">Отследить</button>
        </form>

        <div class="rounded-md bg-slate-100 px-3 py-2.5 text-sm">
          <p :class="statusResult?.toLowerCase().includes('выполнен') ? 'text-green-600 font-semibold' : statusResult?.toLowerCase().includes('выдан') ? 'text-green-600 font-semibold' :  statusResult?.toLowerCase().includes('отклонен') ? 'text-red-600 font-semibold' : 'text-slate-900'">
            Статус вашего заказа: {{ statusResult }}{{statusResult?.toLowerCase().includes('принято') ? ", ожидайте выполнения вашего заказа" : ""}}
          </p>
          <p v-if="statusResult?.toLowerCase().includes('выполнен')" class="mt-2 text-sm font-medium text-green-600">Забрать его можно по адресу ул. Карима Сутюшева 53 в будние дни с 09:00 до 18:00</p>
          <p v-if="statusResult?.toLowerCase().includes('выдан')" class="mt-2 text-sm font-medium text-green-600">Приятного пользования!</p>
        </div>
      </div>
    </section>
  </main>
</template>

<script setup lang='ts'>

import { ref, onMounted } from 'vue'
import { useRuntimeConfig } from '#imports'

// Инициализация reCAPTCHA
const recaptchaLoaded = ref(false)
const recaptchaToken = ref('')
const siteKey = useRuntimeConfig().public.recaptchaSiteKey

// Загрузка reCAPTCHA
const loadRecaptcha = async () => {
  return new Promise<void>((resolve) => {
    if (window.grecaptcha) {
      recaptchaLoaded.value = true
      resolve()
      return
    }

    const script = document.createElement('script')
    script.src = `https://www.google.com/recaptcha/api.js?render=${siteKey}`
    script.async = true
    script.defer = true
    script.onload = () => {
      recaptchaLoaded.value = true
      resolve()
    }
    script.onerror = () => {
      console.error('Failed to load reCAPTCHA script')
      resolve()
    }
    document.head.appendChild(script)
  })
}

// Получение токена
const executeRecaptcha = async (action: string) => {
  try {
    if (!recaptchaLoaded.value) {
      await loadRecaptcha()
    }
    
    return new Promise<string>((resolve, reject) => {
      if (!window.grecaptcha) {
        reject(new Error('reCAPTCHA not loaded'))
        return
      }

      window.grecaptcha.ready(() => {
        window.grecaptcha.execute(siteKey, { action })
          .then(token => {
            recaptchaToken.value = token
            resolve(token)
          })
          .catch(reject)
      })
    })
  } catch (error) {
    console.error('reCAPTCHA error:', error)
    throw error
  }
}

// Инициализация при загрузке
onMounted(async () => {
  await loadRecaptcha()
})


// Механизм проверки по трек номеру 
const track = ref<string>('')
const statusResult = ref<string | null>(null)
const trackRequest = async () => {
  // Проверка заполнения данных
  if (!track.value || !password.value) {
    alert('Введите трек-номер и пароль')
    return
  }

  if (track.value.length !== 12 || password.value.length !== 8) {
    alert('Некорректная длина трек-номера или пароля')
    return
  }

  // Механизм проверки
  try {
    // Токен для капчи
    const token = await executeRecaptcha('track_request')

    // Обращение к эндпоинту
    const res = await $fetch('/api/track-status', {
      method: 'POST',
      body: {
        track_id: track.value,
        password: password.value,
        token
      }
    })

    statusResult.value = res.status
  } catch (error) {
    statusResult.value = 'Заявка не найдена'
  }
}


</script>

<style>
.grecaptcha-badge {
  left: 0 !important;
  right: auto !important;
}
</style>
