<script setup>
const route = useRoute()

const pagesWithChat = ['/', '/form', '/check']
const isAdminPage = computed(() => route.path.startsWith('/admin'))
const isLoginPage = computed(() => route.path === '/login')
const isUserPage = computed(() => !isAdminPage.value && !isLoginPage.value)
const showChatBot = computed(() => pagesWithChat.includes(route.path))
const { selectedLanguage, setLanguage } = useSiteLanguage()

const navText = computed(() => isLoginPage.value ? 'На главную' : selectedLanguage.value === 'kk' ? 'Басты бетке' : 'На главную')
</script>

<template>
  <div v-if="!isAdminPage" class="h-2 bg-slate-800"></div>

  <header v-if="!isAdminPage" class="bg-white shadow-[inset_0_-1px_0_0_rgba(0,0,0,0.08)]">
    <div class="relative mx-auto max-w-7xl px-4 py-3 flex items-center">

      <NuxtLink to="/" class="flex items-center py-2">
        <img
          src="/img/logo.jpg"
          alt="Лого"
          class="h-11 w-auto object-contain"
        />
      </NuxtLink>

      <div class="absolute left-1/2 transform -translate-x-1/2">
        <NuxtLink
          to="/"
          class="select-none uppercase tracking-[0.1em] text-slate-800 hover:text-gray-500 transition-colors max-sm:hidden"
        >
          {{ navText }}
        </NuxtLink>
      </div>

      <div v-if="isUserPage" class="ml-auto flex rounded-md bg-slate-100 p-1">
        <button
          type="button"
          class="rounded px-3 py-1.5 text-xs font-semibold uppercase tracking-[0.08em] text-slate-900 transition hover:bg-white"
          :class="selectedLanguage === 'ru' ? 'bg-[#3FB1F3] text-white shadow-sm hover:bg-[#3FB1F3]' : ''"
          @click="setLanguage('ru')"
        >
          RU
        </button>
        <button
          type="button"
          class="rounded px-3 py-1.5 text-xs font-semibold uppercase tracking-[0.08em] text-slate-900 transition hover:bg-white"
          :class="selectedLanguage === 'kk' ? 'bg-[#3FB1F3] text-white shadow-sm hover:bg-[#3FB1F3]' : ''"
          @click="setLanguage('kk')"
        >
          KZ
        </button>
      </div>
    </div>
  </header>

  <main class="bg-white">
    <slot />
    <FloatingChatBot v-if="showChatBot" />
  </main>
</template>
