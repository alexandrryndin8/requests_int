export type SiteLanguage = 'ru' | 'kk'

export const useSiteLanguage = () => {
  const selectedLanguage = useState<SiteLanguage>('site-language', () => 'ru')

  onMounted(() => {
    const savedLanguage = localStorage.getItem('site-language')
    if (savedLanguage === 'ru' || savedLanguage === 'kk') {
      selectedLanguage.value = savedLanguage
    }
  })

  const setLanguage = (language: SiteLanguage) => {
    selectedLanguage.value = language
    localStorage.setItem('site-language', language)
  }

  return {
    selectedLanguage,
    setLanguage,
  }
}
