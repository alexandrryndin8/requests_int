<template>
  <main class="bg_custom relative z-10 flex min-h-[calc(100vh-5rem)] w-full items-center justify-center px-4 py-6 sm:px-6 lg:py-8">
    <section class="w-full max-w-xl overflow-hidden rounded-sm bg-white shadow-2xl shadow-slate-200/80 ring-1 ring-slate-200/70">
      <header class="px-5 py-7 sm:px-10 sm:py-9">
        <h1 class="text-2xl font-bold tracking-tight text-slate-900 sm:text-3xl">{{ t.title }}</h1>
        <p class="mt-2 text-sm font-medium text-slate-500">{{ t.subtitle }}</p>
      </header>

      <div class="relative h-px bg-slate-200">
        <div class="absolute left-5 top-0 h-px w-24 bg-[#3FB1F3] sm:left-10"></div>
      </div>

      <div class="space-y-5 px-5 py-6 sm:px-10 sm:py-8">
        <form class="space-y-5" @submit.prevent='trackRequest'>
          <div>
            <label for="track_id" class="mb-2 block text-sm font-semibold text-slate-900">{{ t.trackNumber }}</label>
            <input
              type="text"
              id="track_id"
              :placeholder="t.trackPlaceholder"
              class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
              v-model="track"
              maxlength="12"
            >
          </div>

          <div>
            <label for="password" class="mb-2 block text-sm font-semibold text-slate-900">{{ t.password }}</label>
            <input
              type="text"
              id="password"
              :placeholder="t.passwordPlaceholder"
              class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
              v-model="password"
              maxlength="8"
            >
          </div>

          <button class="w-full rounded px-6 py-3 text-sm font-semibold text-white bg-[#3FB1F3] shadow-lg shadow-slate-900/15 transition-transform hover:bg-[#318fc6] active:scale-95" type="submit">{{ t.submit }}</button>
        </form>

        <div class="rounded-md bg-slate-100 px-3 py-2.5 text-sm">
          <p :class="isDoneStatus ? 'text-green-600 font-semibold' : isRejectedStatus ? 'text-red-600 font-semibold' : 'text-slate-900'">
            {{ t.statusPrefix }}: {{ statusText }}{{ isAcceptedStatus ? t.acceptedSuffix : '' }}
          </p>
          <p v-if="isCompletedStatus" class="mt-2 text-sm font-medium text-green-600">{{ t.pickupText }}</p>
          <p v-if="isIssuedStatus" class="mt-2 text-sm font-medium text-green-600">{{ t.issuedText }}</p>
        </div>
      </div>
    </section>
  </main>
</template>

<script setup lang='ts'>

import { ref, computed, onMounted } from 'vue'
import { useReCaptcha } from 'vue-recaptcha-v3'

const { selectedLanguage } = useSiteLanguage()

const translations = {
  ru: {
    title: 'Проверить статус заявки',
    subtitle: 'Введите трек-номер и пароль, чтобы узнать текущий статус.',
    trackNumber: 'Трек-номер',
    trackPlaceholder: 'Введите трек-номер (12 символов)',
    password: 'Пароль',
    passwordPlaceholder: 'Введите пароль (8 символов)',
    submit: 'Отследить',
    statusPrefix: 'Статус вашего заказа',
    acceptedSuffix: ', ожидайте выполнения вашего заказа',
    pickupText: 'Забрать его можно по адресу ул. Карима Сутюшева 53 в будние дни с 09:00 до 18:00',
    issuedText: 'Приятного пользования!',
    missingFieldsAlert: 'Введите трек-номер и пароль',
    invalidLengthAlert: 'Некорректная длина трек-номера или пароля',
    notFound: 'Заявка не найдена',
  },
  kk: {
    title: 'Өтінім мәртебесін тексеру',
    subtitle: 'Ағымдағы мәртебені білу үшін трек-нөмір мен құпиясөзді енгізіңіз.',
    trackNumber: 'Трек-нөмір',
    trackPlaceholder: 'Трек-нөмірді енгізіңіз (12 таңба)',
    password: 'Құпиясөз',
    passwordPlaceholder: 'Құпиясөзді енгізіңіз (8 таңба)',
    submit: 'Тексеру',
    statusPrefix: 'Тапсырысыңыздың мәртебесі',
    acceptedSuffix: ', тапсырысыңыздың орындалуын күтіңіз',
    pickupText: 'Оны Қ.Сүтюшев көшесі, 53 мекенжайынан жұмыс күндері 09:00-ден 18:00-ге дейін алуға болады',
    issuedText: 'Қолдануыңызға сәттілік!',
    missingFieldsAlert: 'Трек-нөмір мен құпиясөзді енгізіңіз',
    invalidLengthAlert: 'Трек-нөмірдің немесе құпиясөздің ұзындығы дұрыс емес',
    notFound: 'Өтінім табылмады',
  },
}

const t = computed(() => translations[selectedLanguage.value])

// reCAPTCHA is loaded once, globally, by plugins/recaptcha.client.ts
// (vue-recaptcha-v3), which only runs client-side. useReCaptcha() must be
// called from a client-only context (onMounted) — calling it directly in
// setup() also runs during SSR, where the plugin was never installed and
// the composable returns undefined.
const recaptchaToken = ref('')
let executeReCaptchaV3: (action: string) => Promise<string>

onMounted(() => {
  executeReCaptchaV3 = useReCaptcha()!.executeRecaptcha
})

const executeRecaptcha = async (action: string) => {
  const token = await executeReCaptchaV3(action)
  recaptchaToken.value = token
  return token
}


// Механизм проверки по трек номеру 
const track = ref<string>('')
const password = ref<string>('')
const statusResult = ref<string | null>(null)
const statusLower = computed(() => statusResult.value?.toLowerCase() || '')
const isCompletedStatus = computed(() => statusLower.value.includes('выполнен'))
const isIssuedStatus = computed(() => statusLower.value.includes('выдан'))
const isAcceptedStatus = computed(() => statusLower.value.includes('принято'))
const isRejectedStatus = computed(() => statusLower.value.includes('отклонен'))
const isDoneStatus = computed(() => isCompletedStatus.value || isIssuedStatus.value)
const statusText = computed(() => {
  if (!statusResult.value) return ''
  if (selectedLanguage.value === 'ru') return statusResult.value
  if (isCompletedStatus.value) return 'Орындалды'
  if (isIssuedStatus.value) return 'Берілді'
  if (isAcceptedStatus.value) return 'Қабылданды'
  if (isRejectedStatus.value) return 'Қабылданбады'
  if (statusLower.value.includes('не найдена')) return t.value.notFound
  return statusResult.value
})

const trackRequest = async () => {
  // Проверка заполнения данных
  if (!track.value || !password.value) {
    alert(t.value.missingFieldsAlert)
    return
  }

  if (track.value.length !== 12 || password.value.length !== 8) {
    alert(t.value.invalidLengthAlert)
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
