<script setup lang="ts">
const { selectedLanguage } = useSiteLanguage()

const translations = {
  ru: {
    heroImageAlt: 'Школа',
    heroTitle: 'Заказ продуктов',
    heroText: 'Здесь вы можете заказать продукты нашей компании, такие как карты, браслеты, брелки и т.д.',
    createRequest: 'Оставить заявку',
    checkRequest: 'Проверить заявку',
    questionsTitle: 'Остались вопросы?',
    questionsText: 'В случае утери, временной блокировки, восстановления или необходимости заказа нового устройства доступа, карта, браслет, брелок, в школу - свяжитесь со службой поддержки компании Интегро удобным для вас способом.',
    address: 'По адресу: К.Сутюшева 53',
    phone: 'Телефон: +7 7152 50 09 19',
    telegramBot: 'Телеграм бот',
    telegramText: 'Подача заявки в боте',
    company: 'Компания Интегро',
    whatsappText: 'Бизнес-аккаунт WhatsApp',
  },
  kk: {
    heroImageAlt: 'Мектеп',
    heroTitle: 'Өнімдерге тапсырыс беру',
    heroText: 'Мұнда сіз компаниямыздың карта, білезік, салпыншақ және басқа да өнімдеріне тапсырыс бере аласыз.',
    createRequest: 'Өтінім қалдыру',
    checkRequest: 'Өтінімді тексеру',
    questionsTitle: 'Сұрақтарыңыз бар ма?',
    questionsText: 'Құрылғы жоғалған, уақытша бұғатталған, қалпына келтіру қажет болған немесе мектепке жаңа қолжетімділік құрылғысына, картаға, білезікке, салпыншаққа тапсырыс беру керек болған жағдайда, Интегро компаниясының қолдау қызметіне өзіңізге ыңғайлы тәсілмен хабарласыңыз.',
    address: 'Мекенжай: Қ.Сүтюшев көшесі, 53',
    phone: 'Телефон: +7 7152 50 09 19',
    telegramBot: 'Telegram бот',
    telegramText: 'Өтінімді бот арқылы беру',
    company: 'Интегро компаниясы',
    whatsappText: 'WhatsApp бизнес-аккаунты',
  },
}

const t = computed(() => translations[selectedLanguage.value])
</script>

<template>
  <main class="bg_custom min-h-screen flex flex-col">
    <!-- HERO SECTION -->
    <section
      class="w-full bg-gradient-to-r from-[#1d64d6] via-[#237fe5] to-[#2a92f1] text-white"
    >
      <div
        class="max-w-6xl mx-auto flex flex-col md:flex-row items-center justify-between gap-8 md:gap-x-8 px-4 sm:px-6 md:px-10 py-8 sm:py-10 md:py-12"
      >
        <div
          class="w-full md:w-1/2 flex items-center justify-center order-1 md:order-none"
        >
          <img
            src="/img/home.png"
            :alt="t.heroImageAlt"
            class="w-full max-w-[280px] sm:max-w-[360px] md:max-w-full h-auto object-contain drop-shadow-lg"
          />
        </div>

        <div
          class="w-full md:w-1/2 flex items-center justify-center order-2 md:order-none"
        >
          <div
            class="max-w-md w-full flex flex-col items-center justify-center text-center"
          >
            <h1
              class="mb-4 md:mb-6 font-bold uppercase text-2xl sm:text-3xl md:text-3xl lg:text-4xl"
            >
              {{ t.heroTitle }}
            </h1>

            <p class="pb-5 md:pb-6 text-sm sm:text-base leading-relaxed">
              {{ t.heroText }}
            </p>

            <div
              class="w-full flex flex-col sm:flex-row gap-3 sm:gap-4 items-center justify-center"
            >
              <NuxtLink
                to="form"
                class="w-full sm:w-auto text-center px-5 py-3 rounded hover:bg-[#cc5d44] text-white bg-[#F26C4F] transition-transform active:scale-95"
              >
                {{ t.createRequest }}
              </NuxtLink>

              <NuxtLink
                to="check"
                class="w-full sm:w-auto text-center px-5 py-3 rounded hover:bg-[#cc5d44] text-white bg-[#F26C4F] transition-transform active:scale-95"
              >
                {{ t.checkRequest }}
              </NuxtLink>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- QUESTIONS SECTION -->
    <section class="w-full">
      <div
        class="max-w-6xl mx-auto flex flex-col lg:flex-row items-center justify-between gap-8 lg:gap-16 px-4 sm:px-6 md:px-10 py-8 sm:py-10 md:py-12"
      >
        <div class="w-full lg:w-1/2 flex items-center justify-center">
          <div
            class="max-w-md w-full flex flex-col items-center justify-center text-center"
          >
            <h1
              class="mb-4 md:mb-6 font-bold uppercase text-2xl sm:text-3xl md:text-3xl lg:text-4xl"
            >
              {{ t.questionsTitle }}
            </h1>

            <p class="pb-5 md:pb-6 text-sm sm:text-base leading-relaxed">
              {{ t.questionsText }}
            </p>

            <div
              class="flex flex-col sm:flex-row gap-1 sm:gap-3 text-slate-500 text-sm sm:text-base"
            >
              <p class="pb-1 sm:pb-6">{{ t.address }}</p>
              <p class="pb-6">{{ t.phone }}</p>
            </div>
          </div>
        </div>

        <div
          class="w-full lg:w-1/2 grid grid-cols-1 sm:grid-cols-2 gap-5 place-items-center"
        >
          <!-- Telegram QR -->
          <div class="flex justify-center items-center w-full">
            <a
              href="https://t.me/integrokzbot"
              target="_blank"
              rel="noopener noreferrer"
              class="w-full max-w-[288px] aspect-square bg-white rounded-3xl shadow-[0_12px_35px_rgba(15,23,42,0.15)] flex flex-col items-center text-center px-6 pt-6 pb-8 transition-transform hover:scale-[1.03] active:scale-95"
            >
              <h2 class="text-lg font-semibold text-slate-900">{{ t.telegramBot }}</h2>

              <p class="text-sm text-slate-500 mb-5">{{ t.telegramText }}</p>

              <img
                src="/img/qr-tg.png"
                alt="QR CODE Telegram"
                class="w-32 h-32 sm:w-36 sm:h-36 object-contain rounded-xl"
              />
            </a>
          </div>

          <!-- WhatsApp QR -->
          <div class="flex justify-center items-center w-full">
            <a
              href="https://wa.me/message/MBQCBYP6MLLBP1?src=qr"
              target="_blank"
              rel="noopener noreferrer"
              class="w-full max-w-[288px] aspect-square bg-white rounded-3xl shadow-[0_12px_35px_rgba(15,23,42,0.15)] flex flex-col items-center text-center px-6 pt-6 pb-8 transition-transform hover:scale-[1.03] active:scale-95"
            >
              <h2 class="text-lg font-semibold text-slate-900">
                {{ t.company }}
              </h2>

              <p class="text-sm text-slate-500 mb-5">{{ t.whatsappText }}</p>

              <img
                src="/img/qr.png"
                alt="QR CODE WhatsApp"
                class="w-32 h-32 sm:w-36 sm:h-36 object-contain rounded-xl"
              />
            </a>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>

<style>
.grecaptcha-badge {
  left: 0 !important;
  right: auto !important;
}
</style>
