<template>
  <main class="bg_custom relative z-10 flex min-h-[calc(100vh-5rem)] w-full items-center justify-center px-4 py-6 sm:px-6 lg:py-8">
    <form class="w-full max-w-xl overflow-hidden rounded-sm bg-white shadow-2xl shadow-slate-200/80 ring-1 ring-slate-200/70" @submit.prevent="postData">
      <header class="px-5 py-7 sm:px-10 sm:py-9">
        <h1 class="text-2xl font-bold tracking-tight text-slate-900 sm:text-3xl">{{ t.title }}</h1>
        <p class="mt-2 text-sm font-medium text-slate-500">{{ t.subtitle }}</p>
      </header>

      <div class="relative h-px bg-slate-200">
        <div class="absolute left-5 top-0 h-px w-24 bg-[#3FB1F3] sm:left-10"></div>
      </div>

      <section class="space-y-5 px-5 py-6 sm:px-10 sm:py-8">
        <div>
          <label for="surname" class="mb-2 block text-sm font-semibold text-slate-900">{{ t.surnameLabel }}</label>
          <input
            type="text"
            id="surname"
            :placeholder="t.surnamePlaceholder"
            class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
            v-model="postsurname"
            :class="errSurname && 'border-red-500 bg-red-50 focus:border-red-500 focus:ring-red-500/10'"
            @blur="validateSurname"
            inputmode="text"
            :pattern="NAME_RE.source"
            :title="t.nameTitle"
          />
          <p v-if="errSurname" class="mt-1 text-xs text-red-600">{{ errSurname }}</p>

          <label for="name" class="mb-2 mt-3 block text-sm font-semibold text-slate-900">{{ t.nameLabel }}</label>
          <input
            type="text"
            id="name"
            :placeholder="t.namePlaceholder"
            class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
            v-model="postname"
            :class="errName && 'border-red-500 bg-red-50 focus:border-red-500 focus:ring-red-500/10'"
            @blur="validateFirstName"
            inputmode="text"
            :pattern="NAME_RE.source"
            :title="t.nameTitle"
          />
          <p v-if="errName" class="mt-1 text-xs text-red-600">{{ errName }}</p>

          <label for="patro" class="mb-2 mt-3 block text-sm font-semibold text-slate-900">{{ t.patronymicLabel }}</label>
          <input
            type="text"
            id="patro"
            :placeholder="t.patronymicPlaceholder"
            class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
            v-model="postpatronymic"
            :class="errPatronymic && 'border-red-500 bg-red-50 focus:border-red-500 focus:ring-red-500/10'"
            @blur="validatePatronymic"
            inputmode="text"
            :pattern="NAME_RE.source"
            :title="t.nameTitle"
          />
          <p v-if="errPatronymic" class="mt-1 text-xs text-red-600">{{ errPatronymic }}</p>
        </div>

        <div>
          <label class="mb-2 block text-sm font-semibold text-slate-900">{{ t.roleLabel }}</label>
          <div class="grid grid-cols-3 gap-2 rounded-md bg-slate-100 p-1">
            <button type="button" class="rounded px-2 py-2.5 text-sm font-semibold text-slate-900 transition" :class="role === 'school' ? 'bg-[#3FB1F3] text-white shadow-sm' : 'hover:bg-white'" @click="setRole('school')">{{ t.schoolRole }}</button>
            <button type="button" class="rounded px-2 py-2.5 text-sm font-semibold text-slate-900 transition" :class="role === 'student' ? 'bg-[#3FB1F3] text-white shadow-sm' : 'hover:bg-white'" @click="setRole('student')">{{ t.studentRole }}</button>
            <button type="button" class="rounded px-2 py-2.5 text-sm font-semibold text-slate-900 transition" :class="role === 'staff' ? 'bg-[#3FB1F3] text-white shadow-sm' : 'hover:bg-white'" @click="setRole('staff')">{{ t.staffRole }}</button>
          </div>
        </div>

        <div>
          <label for="school" class="mb-2 block text-sm font-semibold text-slate-900">{{ t.schoolLabel }}</label>

          <div v-if="postschool" class="flex items-center justify-between gap-3 rounded-md bg-slate-100 px-3 py-2.5 text-sm">
            <span class="min-w-0 break-words text-slate-900">{{ postschool }}</span>
            <button type="button" @click="cancelSchool" class="shrink-0 font-semibold text-slate-500 hover:text-slate-900">{{ t.cancel }}</button>
          </div>

          <div v-else>
            <input
              type="text"
              id="school"
              class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
              :placeholder="t.schoolSearchPlaceholder"
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
          <label class="mb-2 block text-sm font-semibold text-slate-900">{{ t.gradeLabel }}</label>
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
          <label for="group" class="mb-2 block text-sm font-semibold text-slate-900">{{ t.groupLabel }}</label>
          <input
            type="text"
            id="group"
            class="input_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition placeholder:text-slate-400 focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10"
            placeholder="П-22, ISU(US)23-1"
            v-model="group"
            :class="errGroup && 'border-red-500 bg-red-50 focus:border-red-500 focus:ring-red-500/10'"
            @blur="validateGroup"
            :pattern="GROUP_RE.source"
            :title="t.groupTitle"
          />
          <p v-if="errGroup" class="mt-1 text-xs text-red-600">{{ errGroup }}</p>
        </div>

        <div v-else-if="role === 'staff'">
          <label for="group" class="mb-2 block text-sm font-semibold text-slate-900">{{ t.departmentLabel }}</label>
          <div class="flex flex-wrap gap-2">
            <button v-for="department in staffDepartments" :key="department" type="button" class="rounded-md bg-slate-100 px-3 py-1.5 text-sm font-semibold text-slate-900 transition hover:bg-white"
              :class="staffGroup === department ? '!bg-[#3FB1F3] text-white shadow-sm' : ''" @click="staffGroup = department" >{{ departmentLabel(department) }}</button>
          </div>
        </div>

        <div>
          <label for="products" class="mb-2 block text-sm font-semibold text-slate-900">{{ t.productLabel }}</label>
          <select id="products" class="select_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10 disabled:bg-slate-100 disabled:text-slate-500" v-model="productType" :disabled="products.length === 0">
            <option v-if="products.length === 0" value="">
              {{ t.noProducts }}
            </option>
            <option v-for="p in products" :key="p.code" :value="p.name">
              {{ productLabel(p.name) }} ({{ p.price }} {{ t.tenge }})
            </option>
          </select>

          <div v-if="productType === 'Браслет'" class="mt-3">
            <label for="braceletColor" class="mb-2 block text-sm font-semibold text-slate-900">{{ t.braceletColorLabel }}</label>
            <select id="braceletColor" class="select_request w-full rounded-md border-slate-300 bg-white px-3 py-2.5 text-sm text-slate-900 shadow-sm outline-none transition focus:border-[#237fe5] focus:ring-2 focus:ring-[#237fe5]/10" v-model="braceletColor">
              <option v-for="color in braceletColors" :key="color" :value="color">
                {{ colorLabel(color) }}
              </option>
            </select>
          </div>
        </div>

        <button type="button" @click="showModalProductsFunction" class="text-sm font-medium text-slate-500 underline underline-offset-4 transition hover:text-slate-900">
          {{ t.viewProducts }}
        </button>

        <button class="w-full rounded px-6 py-3 text-sm font-semibold  shadow-lg shadow-slate-900/15 transition-transform hover:bg-[#318fc6] text-white bg-[#3FB1F3] active:scale-95" type="submit">{{ t.submit }}</button>
      </section>
    </form>

    <!-- Модальное окно загрузки -->
    <div v-if="isLoading" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4">
      <div class="w-full max-w-md rounded-2xl bg-white p-6 text-center shadow-2xl animate-pulse">
        <p class="text-lg font-semibold text-gray-900">{{ t.loading }}</p>
        <p class="mt-2 text-sm leading-6 text-gray-600">{{ t.loadingHelp }}</p>
      </div>
    </div>

    <!-- Модальное окно после заявки -->
    <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4">
      <div class="w-full max-w-sm rounded-2xl bg-white p-6 text-center shadow-2xl">
        <h2 class="text-xl font-bold text-slate-900">{{ t.requestSent }}</h2>
        <div class="my-5 space-y-2 rounded-xl bg-gray-50 p-4">
          <p class="break-words font-mono text-lg text-blue-600">{{ t.trackNumber }}: {{ track_id }}</p>
          <p class="break-words font-mono text-lg text-blue-600">{{ t.password }}: {{ password }}</p>
        </div>
        <button @click="copyTrackAndPassword" class="button_admin mb-2 w-full rounded-xl px-4 py-2.5 text-sm font-semibold hover:bg-[#318fc6] text-white bg-[#3FB1F3] transition ">{{ t.copyTrackPassword }}</button>
        <button @click="showModal = false" class="button_admin w-full rounded-xl hover:bg-[#318fc6] text-white bg-[#3FB1F3] px-4 py-2.5 text-sm font-semibold transition">{{ t.close }}</button>
      </div>
    </div>

    <!-- Модальное окно посмотреть товары -->
    <div v-if="showModalProducts" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 px-4">
      <div class="w-full max-w-sm overflow-hidden rounded-2xl bg-white text-center shadow-2xl">
        <h2 class="px-5 pt-5 text-lg font-bold text-slate-900">{{ t.availableProducts }}</h2>
        <img src="public\img\products.png" class="w-full px-5 py-4" :alt="t.availableProducts" />
        <button @click="showModalProducts = false" class="button_admin mb-5 rounded-xl px-5 py-2.5 text-sm font-semibold transition hover:bg-[#318fc6] text-white bg-[#3FB1F3]">{{ t.close }}</button>
      </div>
    </div>
  </main>
</template>


<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'
import { useReCaptcha } from 'vue-recaptcha-v3'

const { selectedLanguage } = useSiteLanguage()

const translations = {
  ru: {
    title: 'Заявка на устройство доступа',
    subtitle: 'Есть вопросы? Нажмите на знак вопроса справа снизу для онлайн консультации',
    surnameLabel: 'Введите вашу фамилию',
    surnamePlaceholder: 'Иванов',
    nameLabel: 'Введите ваше имя',
    namePlaceholder: 'Иван',
    patronymicLabel: 'Введите ваше отчество',
    patronymicPlaceholder: 'Иванович',
    nameTitle: 'Только русские/казахские буквы и дефис',
    roleLabel: 'Выберите вашу роль',
    schoolRole: 'Школьник',
    studentRole: 'Студент',
    staffRole: 'Сотрудник',
    schoolLabel: 'Выберите учебное заведение',
    cancel: 'Отменить',
    schoolSearchPlaceholder: 'Поиск учебных заведений',
    gradeLabel: 'Выберите класс',
    groupLabel: 'Введите группу',
    groupTitle: 'Буквы, цифры, пробел, - _ ( ) / (2-32 символа)',
    departmentLabel: 'Выберите подразделение',
    productLabel: 'Выберите устройство доступа',
    noProducts: 'Нет доступных устройств',
    tenge: 'тенге',
    braceletColorLabel: 'Выберите цвет браслета',
    viewProducts: 'Посмотреть продукты',
    submit: 'Оставить заявку',
    loading: 'Загрузка...',
    loadingHelp: 'Если загрузка не заканчивается, попробуйте почистить кэш и куки и подать еще раз',
    requestSent: 'Заявка отправлена!',
    trackNumber: 'Трек-номер',
    password: 'Пароль',
    copyTrackPassword: 'Скопировать трек и пароль',
    close: 'Закрыть',
    availableProducts: 'Доступные продукты',
    nameLengthError: 'Должно быть от 2 до 50 символов',
    nameLettersError: 'Только русские/казахские буквы и дефис',
    groupRequiredError: 'Укажите группу',
    groupFormatError: 'Можно: буквы, цифры, пробел, - _ ( ) / (2-32 симв.)',
    checkFieldsAlert: 'Проверьте корректность полей',
    fillAllAlert: 'Пожалуйста, заполните все поля заявки',
    recaptchaError: 'Ошибка проверки reCAPTCHA. Пожалуйста, попробуйте еще раз.',
    duplicateAlert: 'Ваша заявка уже подана и находится в обработке.',
    submitError: 'Произошла ошибка при отправке формы: ',
    unknownError: 'Неизвестная ошибка',
    copiedAlert: 'Трек и пароль скопированы в буфер обмена',
    copyErrorAlert: 'Ошибка при копировании',
  },
  kk: {
    title: 'Қолжетімділік құрылғысына өтінім',
    subtitle: 'Сұрақтарыңыз бар ма? Онлайн кеңес алу үшін төменгі оң жақтағы сұрақ белгісін басыңыз',
    surnameLabel: 'Тегіңізді енгізіңіз',
    surnamePlaceholder: 'Иванов',
    nameLabel: 'Атыңызды енгізіңіз',
    namePlaceholder: 'Иван',
    patronymicLabel: 'Әкеңіздің атын енгізіңіз',
    patronymicPlaceholder: 'Иванович',
    nameTitle: 'Тек орыс/қазақ әріптері және дефис',
    roleLabel: 'Рөліңізді таңдаңыз',
    schoolRole: 'Оқушы',
    studentRole: 'Студент',
    staffRole: 'Қызметкер',
    schoolLabel: 'Оқу орнын таңдаңыз',
    cancel: 'Болдырмау',
    schoolSearchPlaceholder: 'Оқу орнын іздеу',
    gradeLabel: 'Сыныпты таңдаңыз',
    groupLabel: 'Топты енгізіңіз',
    groupTitle: 'Әріптер, сандар, бос орын, - _ ( ) / (2-32 таңба)',
    departmentLabel: 'Бөлімшені таңдаңыз',
    productLabel: 'Қолжетімділік құрылғысын таңдаңыз',
    noProducts: 'Қолжетімді құрылғылар жоқ',
    tenge: 'теңге',
    braceletColorLabel: 'Білезіктің түсін таңдаңыз',
    viewProducts: 'Өнімдерді қарау',
    submit: 'Өтінім қалдыру',
    loading: 'Жүктелуде...',
    loadingHelp: 'Егер жүктеу аяқталмаса, кэш пен cookie файлдарын тазалап, қайта жіберіп көріңіз',
    requestSent: 'Өтінім жіберілді!',
    trackNumber: 'Трек-нөмір',
    password: 'Құпиясөз',
    copyTrackPassword: 'Трек пен құпиясөзді көшіру',
    close: 'Жабу',
    availableProducts: 'Қолжетімді өнімдер',
    nameLengthError: '2-ден 50 таңбаға дейін болуы керек',
    nameLettersError: 'Тек орыс/қазақ әріптері және дефис',
    groupRequiredError: 'Топты көрсетіңіз',
    groupFormatError: 'Болады: әріптер, сандар, бос орын, - _ ( ) / (2-32 таңба)',
    checkFieldsAlert: 'Өрістердің дұрыс толтырылғанын тексеріңіз',
    fillAllAlert: 'Өтінімнің барлық өрістерін толтырыңыз',
    recaptchaError: 'reCAPTCHA тексеру қатесі. Қайтадан көріңіз.',
    duplicateAlert: 'Сіздің өтініміңіз бұрын жіберілген және өңделіп жатыр.',
    submitError: 'Форманы жіберу кезінде қате пайда болды: ',
    unknownError: 'Белгісіз қате',
    copiedAlert: 'Трек пен құпиясөз буферге көшірілді',
    copyErrorAlert: 'Көшіру кезінде қате пайда болды',
  },
}

const t = computed(() => translations[selectedLanguage.value])
const departmentTranslations: Record<string, { ru: string; kk: string }> = {
  'Администрация': { ru: 'Администрация', kk: 'Әкімшілік' },
  'Пед. состав': { ru: 'Пед. состав', kk: 'Пед. құрам' },
  'Тех. персонал': { ru: 'Тех. персонал', kk: 'Тех. персонал' },
  'Другое': { ru: 'Другое', kk: 'Басқа' },
}
const productTranslations: Record<string, { ru: string; kk: string }> = {
  'Карта': { ru: 'Карта', kk: 'Карта' },
  'Браслет': { ru: 'Браслет', kk: 'Білезік' },
  'Брелок': { ru: 'Брелок', kk: 'Салпыншақ' },
}
const colorTranslations: Record<string, { ru: string; kk: string }> = {
  'Черный': { ru: 'Черный', kk: 'Қара' },
  'Белый': { ru: 'Белый', kk: 'Ақ' },
  'Красный': { ru: 'Красный', kk: 'Қызыл' },
  'Синий': { ru: 'Синий', kk: 'Көк' },
  'Зеленый': { ru: 'Зеленый', kk: 'Жасыл' },
  'Желтый': { ru: 'Желтый', kk: 'Сары' },
}
const departmentLabel = (department: string) => departmentTranslations[department]?.[selectedLanguage.value] || department
const productLabel = (product: string) => productTranslations[product]?.[selectedLanguage.value] || product
const colorLabel = (color: string) => colorTranslations[color]?.[selectedLanguage.value] || color

// Разрешаем только рус/каз буквы + дефис, длина 2–50
const NAME_RE = /^[А-ЯЁӘІҢҒҚӨҰҮҺа-яёәіңғқөұүһ\-]+$/u
const GROUP_RE = /^[A-Za-zА-ЯЁӘІҢҒҚӨҰҮҺа-яёәіңғқөұүһ0-9()_\-\/ ]{2,32}$/u

function validateNamePart(s: string) {
  const v = (s || '').trim()
  if (v.length < 2 || v.length > 50) return t.value.nameLengthError
  if (!NAME_RE.test(v)) return t.value.nameLettersError
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
  if (!v) { errGroup.value = t.value.groupRequiredError; return }
  errGroup.value = GROUP_RE.test(v) ? '' : t.value.groupFormatError
  group.value = v
}

// reCAPTCHA is loaded once, globally, by plugins/recaptcha.client.ts
// (vue-recaptcha-v3). Loading the api.js script again here would create a
// second, conflicting reCAPTCHA client and break verification.
const recaptchaToken = ref<string>('')
const { executeRecaptcha } = useReCaptcha()!


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
    await executeRecaptcha('homepage')
    showRecaptchaBadge()
    // Повторная проверка каждые 2 секунды (на случай динамического скрытия)
    setInterval(showRecaptchaBadge, 2000)
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
    alert(t.value.checkFieldsAlert)
    return
  }
  isLoading.value = true                 
  try {
    const postfull_name = computed(() => getFullName(postsurname.value, postname.value, postpatronymic.value))
    if (!postfull_name.value || !postschool.value || !postclass.value || !postdevice_type.value) {
      alert(t.value.fillAllAlert)
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
      alert(t.value.recaptchaError)
    } else if (error.statusCode === 409) {
      alert(t.value.duplicateAlert)
    } else {
      alert(t.value.submitError + (error.message || t.value.unknownError))
    }
  } finally {
    isLoading.value = false              // ← критично: всегда выключаем спиннер
  }
}

// Копирование трек номера и пароля
const copyTrackAndPassword = () => {
  if (track_id.value && password.value) {
    const textToCopy = `${t.value.trackNumber}: ${track_id.value}, ${t.value.password}: ${password.value}`
    navigator.clipboard.writeText(textToCopy).then(() => {
      alert(t.value.copiedAlert)
    }).catch(() => {
      alert(t.value.copyErrorAlert)
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
