<template>
  <main class="bg_custom relative z-10 grid w-full place-items-center px-4 py-6 sm:px-6 lg:py-8" style="min-height: calc(100vh - 88px);">
    <section class="mx-auto w-full max-w-xl overflow-hidden rounded-sm bg-white shadow-2xl shadow-slate-200/80 ring-1 ring-slate-200/70">
      <header class="px-5 py-7 sm:px-10 sm:py-9">
        <h1 class="text-2xl font-bold tracking-tight text-slate-900 sm:text-3xl">Войдите в админ-панель</h1>
        <p class="mt-2 text-sm font-medium text-slate-500">Введите логин и пароль для доступа к управлению заявками.</p>
      </header>

      <div class="relative h-px bg-slate-200">
        <div class="absolute left-5 top-0 h-px w-24 bg-[#3FB1F3] sm:left-10"></div>
      </div>

      <form @submit.prevent="login" class="space-y-5 px-5 py-6 sm:px-10 sm:py-8">
        <div>
          <label for="username" class="mb-2 block text-sm font-semibold text-slate-900">Логин</label>
          <input
            id="username"
            v-model="username"
            type="text"
            placeholder="Username"
            class="input w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
          />
        </div>

        <div>
          <label for="password" class="mb-2 block text-sm font-semibold text-slate-900">Пароль</label>
          <input
            id="password"
            v-model="password"
            type="password"
            placeholder="Password"
            class="input w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
          />
        </div>

        <button type="submit" class="w-full rounded bg-[#3FB1F3] px-6 py-3 text-sm font-semibold text-white shadow-lg shadow-slate-900/15 transition-transform hover:bg-[#318fc6] active:scale-95">Войти</button>

        <p class="rounded-md bg-slate-100 px-3 py-2.5 text-sm font-medium text-slate-500">Тестовые данные для входа: superadmin admin</p>
        <p v-if="error" class="rounded-md bg-red-50 px-3 py-2.5 text-sm font-semibold text-red-600">
          {{ error }}
        </p>
      </form>
    </section>
  </main>
</template>

<script setup lang="ts">
const username = ref('')
const password = ref('')
const error = ref('')

// Инициализация reCAPTCHA
const recaptchaLoaded = ref(false)
const siteKey = useRuntimeConfig().public.recaptchaSiteKey

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

const executeRecaptcha = async (action: string) => {
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
        .then(resolve)
        .catch(reject)
    })
  })
}

onMounted(async () => {
  await loadRecaptcha()
})

async function login() {
  error.value = ''
  try {
    const token = await executeRecaptcha('login')

    await $fetch('/api/login', {
      method: 'POST',
      body: {
        username: username.value,
        password: password.value,
        token
      }
    })

    // ⚠️ Критично — нужна полная перезагрузка, чтобы SSR "увидел" куку
    window.location.href = '/admin'
  } catch (err: any) {
    if (err?.status === 429) {
      error.value = 'Слишком много попыток входа. Подождите 5 минут.'
    } else {
      error.value = err?.data?.message || 'Login failed'
    }
  }
}

</script>
