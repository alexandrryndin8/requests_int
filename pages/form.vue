<template>
  <main class="bg_custom relative z-10 flex min-h-[calc(100vh-5rem)] w-full items-center justify-center px-4 py-6 sm:px-6 lg:py-8">
    <form class="w-full max-w-xl overflow-hidden rounded-sm bg-white shadow-2xl shadow-slate-200/80 ring-1 ring-slate-200/70" @submit.prevent="postData">
      <header class="px-5 py-7 sm:px-10 sm:py-9">
        <h1 class="text-2xl font-bold tracking-tight text-slate-900 sm:text-3xl">Заявка на устройство доступа</h1>
        <p class="mt-2 text-sm font-medium text-slate-500">Заполните данные ниже, чтобы отправить заявку.</p>
      </header>

      <div class="relative h-px bg-slate-200">
        <div class="absolute left-5 top-0 h-px w-24 bg-[#3FB1F3] sm:left-10"></div>
      </div>

      <section class="space-y-5 px-5 py-6 sm:px-10 sm:py-8">
        <div>
          <label for="surname" class="mb-2 block text-sm font-semibold text-slate-900">Введите вашу фамилию</label>
          <input
            type="text"
            id="surname"
            placeholder="Иванов"
            class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
            v-model="postsurname"
            :class="errSurname && 'border-red-500 bg-red-50 focus:border-red-500 focus:ring-red-500/10'"
            @blur="validateSurname"
            inputmode="text"
            :pattern="NAME_RE.source"
            title="Только русские/казахские буквы и дефис"
          />
          <p v-if="errSurname" class="mt-1 text-xs text-red-600">{{ errSurname }}</p>

          <label for="name" class="mb-2 mt-3 block text-sm font-semibold text-slate-900">Введите ваше имя</label>
          <input
            type="text"
            id="name"
            placeholder="Иван"
            class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
            v-model="postname"
            :class="errName && 'border-red-500 bg-red-50 focus:border-red-500 focus:ring-red-500/10'"
            @blur="validateFirstName"
            inputmode="text"
            :pattern="NAME_RE.source"
            title="Только русские/казахские буквы и дефис"
          />
          <p v-if="errName" class="mt-1 text-xs text-red-600">{{ errName }}</p>

          <label for="patro" class="mb-2 mt-3 block text-sm font-semibold text-slate-900">Введите ваше отчество</label>
          <input
            type="text"
            id="patro"
            placeholder="Иванович"
            class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
            v-model="postpatronymic"
            :class="errPatronymic && 'border-red-500 bg-red-50 focus:border-red-500 focus:ring-red-500/10'"
            @blur="validatePatronymic"
            inputmode="text"
            :pattern="NAME_RE.source"
            title="Только русские/казахские буквы и дефис"
          />
          <p v-if="errPatronymic" class="mt-1 text-xs text-red-600">{{ errPatronymic }}</p>
        </div>

        <div>
          <label class="mb-2 block text-sm font-semibold text-slate-900">Выберите вашу роль</label>
          <div class="grid grid-cols-3 gap-2 rounded-md bg-slate-100 p-1">
            <button type="button" class="rounded px-2 py-2.5 text-sm font-semibold text-slate-900 transition" :class="role === 'school' ? 'bg-[#3FB1F3] text-white shadow-sm' : 'hover:bg-white'" @click="setRole('school')">Школьник</button>
            <button type="button" class="rounded px-2 py-2.5 text-sm font-semibold text-slate-900 transition" :class="role === 'student' ? 'bg-[#3FB1F3] text-white shadow-sm' : 'hover:bg-white'" @click="setRole('student')">Студент</button>
            <button type="button" class="rounded px-2 py-2.5 text-sm font-semibold text-slate-900 transition" :class="role === 'staff' ? 'bg-[#3FB1F3] text-white shadow-sm' : 'hover:bg-white'" @click="setRole('staff')">Сотрудник</button>
          </div>
        </div>

        <div>
          <label for="school" class="mb-2 block text-sm font-semibold text-slate-900">Выберите учебное заведение</label>

          <div v-if="postschool" class="flex items-center justify-between gap-3 rounded-md bg-slate-100 px-3 py-2.5 text-sm">
            <span class="min-w-0 break-words text-slate-900">{{ postschool }}</span>
            <button type="button" @click="cancelSchool" class="shrink-0 font-semibold text-slate-500 hover:text-slate-900">Отменить</button>
          </div>

          <div v-else>
            <input
              type="text"
              id="school"
              class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
              placeholder="Поиск учебных заведений"
              v-model="schoolSearch"
            />
            <div class="mt-2 max-h-44 overflow-y-auto rounded-md bg-slate-50 p-1">
              <button
                v-for="school in searchedSchools"
                :key="school.id"
                class="block w-full rounded px-3 py-2 text-left text-sm text-slate-900 transition hover:bg-white"
                @click.prevent="selectSchool(school.name)"
              >
                {{ school.name }}
              </button>
            </div>
          </div>
        </div>

        <div v-if="role === 'school'">
          <label class="mb-2 block text-sm font-semibold text-slate-900">Выберите класс</label>
          <div class="mb-2 flex flex-wrap gap-2">
            <button type="button" class="rounded-md bg-slate-100 px-3 py-1.5 text-sm font-semibold text-slate-900 transition hover:bg-white" :class="grade === num.toString() ? '!bg-[#3FB1F3] text-white shadow-sm' : ''" v-for="num in 12" :key="num" @click="grade = num.toString()">
              {{ num }}
            </button>
          </div>
          <div class="flex flex-wrap gap-2">
            <button type="button" class="rounded-md bg-slate-100 px-3 py-1.5 text-sm font-semibold text-slate-900 transition hover:bg-white" :class="letter === l && '!bg-[#3FB1F3] text-white shadow-sm'" v-for="l in letters" :key="l" @click="letter = l">
              {{ l }}
            </button>
          </div>
        </div>

        <div v-else-if="role === 'student'">
          <label for="group" class="mb-2 block text-sm font-semibold text-slate-900">Введите группу</label>
          <input
            type="text"
            id="group"
            class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
            placeholder="П-22, ISU(US)23-1"
            v-model="group"
            :class="errGroup && 'border-red-500 bg-red-50 focus:border-red-500 focus:ring-red-500/10'"
            @blur="validateGroup"
            :pattern="GROUP_RE.source"
            title="Буквы, цифры, пробел, - _ ( ) / (2–32 символа)"
          />
          <p v-if="errGroup" class="mt-1 text-xs text-red-600">{{ errGroup }}</p>
        </div>

        <div v-else-if="role === 'staff'">
          <label for="group" class="mb-2 block text-sm font-semibold text-slate-900">Выберите подразделение</label>
          <div class="flex flex-wrap gap-2">
            <button v-for="department in staffDepartments" :key="department" type="button" class="rounded-md bg-slate-100 px-3 py-1.5 text-sm font-semibold text-slate-900 transition hover:bg-white"
              :class="staffGroup === department ? '!bg-[#3FB1F3] text-white shadow-sm' : ''" @click="staffGroup = department" >{{ department }}</button>
          </div>
        </div>

        <div>
          <label for="products" class="mb-2 block text-sm font-semibold text-slate-900">Выберите устройство доступа</label>
          <select id="products" class="select_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10 disabled:bg-slate-100 disabled:text-slate-500" v-model="productType" :disabled="products.length === 0">
            <option v-if="products.length === 0" value="">
              Нет доступных устройств
            </option>
            <option v-for="p in products" :key="p.code" :value="p.name">
              {{ p.name }} ({{ p.price }} тенге)
            </option>
          </select>

          <div v-if="productType === 'Браслет'" class="mt-3">
            <label for="braceletColor" class="mb-2 block text-sm font-semibold text-slate-900">Выберите цвет браслета</label>
            <select id="braceletColor" class="select_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10" v-model="braceletColor">
              <option v-for="color in braceletColors" :key="color" :value="color">
                {{ color }}
              </option>
            </select>
          </div>
        </div>

        <button type="button" @click="showModalProductsFunction" class="text-sm font-medium text-slate-500 underline underline-offset-4 transition hover:text-slate-900">
          Посмотреть продукты
        </button>

        <button class="w-full rounded px-6 py-3 text-sm font-semibold  shadow-lg shadow-slate-900/15 transition-transform hover:bg-[#318fc6] text-white bg-[#3FB1F3] active:scale-95" type="submit">Оставить заявку</button>
      </section>
    </form>

    <!-- Модальное окно загрузки -->
    <div v-if="isLoading" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4">
      <div class="w-full max-w-md rounded-2xl bg-white p-6 text-center shadow-2xl animate-pulse">
        <p class="text-lg font-semibold text-gray-900">Загрузка…</p>
        <p class="mt-2 text-sm leading-6 text-gray-600">Если загрузка не заканчивается попробуйте почистить кэш и куки и подать еще раз</p>
      </div>
    </div>

    <!-- Модальное окно после заявки -->
    <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4">
      <div class="w-full max-w-sm rounded-2xl bg-white p-6 text-center shadow-2xl">
        <h2 class="text-xl font-bold text-slate-900">Заявка отправлена!</h2>
        <div class="my-5 space-y-2 rounded-xl bg-gray-50 p-4">
          <p class="break-words font-mono text-lg text-blue-600">Трек-номер: {{ track_id }}</p>
          <p class="break-words font-mono text-lg text-blue-600">Пароль: {{ password }}</p>
        </div>
        <button @click="copyTrackAndPassword" class="button_admin mb-2 w-full rounded-xl px-4 py-2.5 text-sm font-semibold hover:bg-[#318fc6] text-white bg-[#3FB1F3] transition ">Скопировать трек и пароль</button>
        <button @click="showModal = false" class="button_admin w-full rounded-xl hover:bg-[#318fc6] text-white bg-[#3FB1F3] px-4 py-2.5 text-sm font-semibold transition">Закрыть</button>
      </div>
    </div>

    <!-- Модальное окно посмотреть товары -->
    <div v-if="showModalProducts" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4">
      <div class="w-full max-w-sm overflow-hidden rounded-2xl bg-white text-center shadow-2xl">
        <h2 class="px-5 pt-5 text-lg font-bold text-slate-900">Доступные продукты</h2>
        <img src="public\img\products.png" class="w-full px-5 py-4" alt="Доступные продукты" />
        <button @click="showModalProducts = false" class="button_admin mb-5 rounded-xl px-5 py-2.5 text-sm font-semibold transition hover:bg-[#318fc6] text-white bg-[#3FB1F3]">Закрыть</button>
      </div>
    </div>
  </main>
</template>


<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useRuntimeConfig } from '#imports'

// Разрешаем только рус/каз буквы + дефис, длина 2–50
const NAME_RE = /^[А-ЯЁӘІҢҒҚӨҰҮҺа-яёәіңғқөұүһ\-]+$/u
const GROUP_RE = /^[A-Za-zА-ЯЁӘІҢҒҚӨҰҮҺа-яёәіңғқөұүһ0-9()_\-\/ ]{2,32}$/u

function validateNamePart(s: string) {
  const v = (s || '').trim()
  if (v.length < 2 || v.length > 50) return 'Должно быть от 2 до 50 символов'
  if (!NAME_RE.test(v)) return 'Только русские/казахские буквы и дефис'
  return '' // ок
}

function normalizeGroup(raw: string) {
  return (raw || '')
    .trim()
    .replace(/\s+/g, ' ')
}

// ошибки для инпутов
const errSurname = ref('')
const errName = ref('')
const errPatronymic = ref('')
const errGroup = ref('')

// хелперы для onBlur
function validateSurname() { errSurname.value = validateNamePart(postsurname.value) }
function validateFirstName() { errName.value = validateNamePart(postname.value) }
function validatePatronymic() {
  const v = (postpatronymic.value || '').trim()
  errPatronymic.value = v ? validateNamePart(v) : ''
}
function validateGroup() {
  const v = normalizeGroup(group.value)
  if (!v) { errGroup.value = 'Укажите группу'; return }
  errGroup.value = GROUP_RE.test(v) ? '' : 'Можно: буквы, цифры, пробел, - _ ( ) / (2–32 симв.)'
  group.value = v
}

// Переменные для работы капчи
const recaptchaToken = ref<string>('')
const recaptchaLoaded = ref(false)

const { $recaptcha } = useNuxtApp()
const siteKey = useRuntimeConfig().public.recaptchaSiteKey

// Запуск капчи
const executeRecaptcha = async (action: string) => {
  try {
    if (!recaptchaLoaded.value) {
      await loadRecaptcha()
    }

    return await new Promise<string>((resolve, reject) => {
      grecaptcha.ready(() => {
        grecaptcha.execute(siteKey, { action })
          .then(resolve)
          .catch(reject)
      })
    })
  } catch (error) {
    console.error('reCAPTCHA execution error:', error)
    throw error
  }
}


// Создание полного имени из полей 
function getFullName(surname: string, name: string, patronymic: string): string {
  return [surname, name, patronymic].filter(Boolean).join(' ')
}

// Переменные для взаимодействия с базой
const postsurname = ref('')
const postname = ref('')
const postpatronymic = ref('')
const postschool = ref('')
const postclass = ref('')
const role = ref<'school' | 'student' | 'staff' | null>(null)
const grade = ref('')
const letter = ref('')
const group = ref('')
const password = ref('')
const track_id = ref<string | null>(null)
const schools = ref<{ id: number, name: string, type: string }[]>([])
const letters = ['А', 'Ә', 'Б', 'В', 'Г', 'Ғ', 'Д', 'Е', 'Ë', 'Ж', 'З', 'Ы']
const productType = ref('')
const braceletColor = ref('')
const staffGroup = ref('')
const staffDepartments = ['Администрация', 'Пед. состав', 'Тех. персонал', 'Другое']



// Переменные для модалок
const showModal = ref(false)
const isLoading = ref(false)
const showModalProducts = ref(false)
const showModalProductsFunction = () => {
  showModalProducts.value = true;
}

// Совмещение браслета и его цвета
const postdevice_type = computed(() => {
  if (productType.value === 'Браслет' && braceletColor.value) {
    return `Браслет (${braceletColor.value})`
  }
  return productType.value
})

// Функция перезагрузки формы
const resetForm = () => {
  postsurname.value = ''
  postname.value = ''
  postpatronymic.value = ''
  postschool.value = ''
  schoolSearch.value = ''
  postclass.value = ''
  productType.value = 'Карта'
  braceletColor.value = ''
  grade.value = ''
  letter.value = ''
  group.value = ''
  role.value = null
}

// Выбор роли при подаче заявки
const setRole = (value: typeof role.value) => {
  role.value = value
  grade.value = ''
  letter.value = ''
  group.value = ''
  staffGroup.value = ''
  postschool.value = ''
  postclass.value = ''
}

// Выставление учебного заведения в зависимости от роли
const filteredSchools = computed(() => {
  if (role.value === 'school') {
    return schools.value.filter(s => s.type !== 'колледж')
  } else if (role.value === 'student') {
    return schools.value.filter(s => s.type === 'колледж')
  }
  return schools.value
})

// Получение школ из базы
onMounted(async () => {
  const res = await $fetch('/api/all-schools')
  schools.value = res.schools
})

type Product = { code: string; name: string; price: number; colors: string[] }
const products = ref<Product[]>([])
const pricesMap = computed(() => Object.fromEntries(products.value.map(p => [p.name, p.price])))
const braceletColors = computed(() =>
  products.value.find((product) => product.name === 'Браслет')?.colors || []
)

onMounted(async () => {
  const res = await $fetch<{ products: Product[] }>('/api/products')
  products.value = res.products
  if (!products.value.some((product) => product.name === productType.value)) {
    productType.value = ''
  }

  // если productType пустой или не существует в списке — ставим первый
  if (!productType.value && products.value.length) {
    productType.value = products.value[0].name
  }
})

watch([productType, braceletColors], () => {
  if (productType.value === 'Браслет') {
    if (!braceletColor.value || !braceletColors.value.includes(braceletColor.value)) {
      braceletColor.value = braceletColors.value[0] || ''
    }
  } else {
    braceletColor.value = ''
  }
}, { immediate: true })

// Установка класса в зависимости от роли
watch([role, grade, letter, group, staffGroup], () => {
  if (role.value === 'school') {
    postclass.value = grade.value && letter.value ? `${grade.value}${letter.value}` : ''
  } else if (role.value === 'student') {
    postclass.value = group.value
  } else if (role.value === 'staff') {
    postclass.value = staffGroup.value ? `Сотрудник: ${staffGroup.value}` : ''
  } else {
    postclass.value = ''
  }
}, { immediate: true }) 

// Прогрузка капчи
const loadRecaptcha = () => {
  return new Promise<void>((resolve, reject) => {
    if (window.grecaptcha) {
      recaptchaLoaded.value = true
      return resolve()
    }

    const script = document.createElement('script')
    script.src = `https://www.google.com/recaptcha/api.js?render=${siteKey}`
    script.async = true
    script.defer = true
    script.onload = () => {
      recaptchaLoaded.value = true
      resolve()
    }
    script.onerror = (err) => {
      console.error('reCAPTCHA script failed to load', err)
      reject(new Error('Failed to load reCAPTCHA'))
    }
    document.head.appendChild(script)
  })
}


// Показ значка капчи
const showRecaptchaBadge = () => {
  const badge = document.querySelector('.grecaptcha-badge')
  if (badge) {
    const style = badge.style
    style.setProperty('left', '0', 'important')
    style.setProperty('right', 'auto', 'important')
    style.setProperty('visibility', 'visible', 'important')
    style.setProperty('opacity', '1', 'important')
    style.setProperty('transition', 'none', 'important')
  }
}

onMounted(async () => {
  if (process.client) {
    await loadRecaptcha()
    console.log('reCAPTCHA successfully loaded')
    grecaptcha.ready(() => {
      grecaptcha.execute(useRuntimeConfig().public.recaptchaSiteKey, {
        action: 'homepage'
      }).then(() => {
        showRecaptchaBadge()
        // Повторная проверка каждые 2 секунды (на случай динамического скрытия)
        setInterval(showRecaptchaBadge, 2000)
      })
    })
  }
})

// Отправка данных в базу
const postData = async () => {
  if (isLoading.value) return           

  validateSurname(); validateFirstName(); validatePatronymic();
  if (role.value === 'student' && typeof validateGroup === 'function') {
    validateGroup()
  }

  if (errSurname.value || errName.value || (role.value === 'student' && errGroup?.value)) {
    alert('Проверьте корректность полей')
    return
  }
  isLoading.value = true                 
  try {
    const postfull_name = computed(() => getFullName(postsurname.value, postname.value, postpatronymic.value))
    if (!postfull_name.value || !postschool.value || !postclass.value || !postdevice_type.value) {
      alert('Пожалуйста, заполните все поля заявки')
      return
    }

    const token = await executeRecaptcha('submit_form')
    if (!token) throw new Error('Не удалось получить токен reCAPTCHA')

    const response = await $fetch("/api/requests", {
      method: "POST",
      body: {
        full_name: postfull_name.value,
        school: postschool.value,
        class: postclass.value,
        device_type: postdevice_type.value,
        token: token,
        source: 'Сайт'
      }
    })

    track_id.value = response.user.track_id
    password.value = response.user.password
    showModal.value = true
    resetForm()
  } catch (error: any) {
    console.error('Ошибка при отправке формы:', error)
    if (error.statusCode === 403) {
      alert('Ошибка проверки reCAPTCHA. Пожалуйста, попробуйте еще раз.')
    } else if (error.statusCode === 409) {
      alert('Ваша заявка уже подана и находится в обработке.')
    } else {
      alert('Произошла ошибка при отправке формы: ' + (error.message || 'Неизвестная ошибка'))
    }
  } finally {
    isLoading.value = false              // ← критично: всегда выключаем спиннер
  }
}

// Копирование трек номера и пароля
const copyTrackAndPassword = () => {
  if (track_id.value && password.value) {
    const textToCopy = `Трек: ${track_id.value}, Пароль: ${password.value}`
    navigator.clipboard.writeText(textToCopy).then(() => {
      alert('Трек и пароль скопированы в буфер обмена')
    }).catch(() => {
      alert('Ошибка при копировании')
    })
  }
}

// Фильтрация для пикера 
const schoolSearch = ref('')

const searchedSchools = computed(() => {
  const query = schoolSearch.value.trim().toLowerCase()
  if (!query) return filteredSchools.value 
  return filteredSchools.value.filter(s =>
    s.name.toLowerCase().includes(query)
  )
})

const selectSchool = (name: string) => {
  postschool.value = name
  schoolSearch.value = name 
}

const cancelSchool = () => {
  postschool.value = ''
  schoolSearch.value = ''
}
</script>

<style>
/* Защита от clickjacking */
body {
  display: block !important;
  position: relative !important;
}

[style*="opacity:0"], [style*="opacity: 0"], 
[style*="visibility:hidden"], [style*="visibility: hidden"] {
  pointer-events: none !important;
}

/* Показ значка капчи */
.grecaptcha-badge {
  left: 0 !important;
  right: auto !important;
  visibility: visible !important;
  opacity: 1 !important;
  transition: none !important;
  z-index: 9999 !important;
  pointer-events: all !important;
}

</style>
