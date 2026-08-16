// https://nuxt.com/docs/api/configuration/nuxt-config
import { createResolver } from "@nuxt/kit";

const resolver = createResolver(import.meta.url);

export default defineNuxtConfig({
  compatibilityDate: "2024-11-01",
  devtools: { enabled: true },
  modules: ["@nuxtjs/tailwindcss"],
  css: ["@/assets/css/main.css", "@/assets/css/fonts.css"],

  runtimeConfig: {
    BOT_TOKEN: process.env.TELEGRAM_BOT_TOKEN,
    JWT_SECRET: process.env.JWT_SECRET,
    RECAPTCHA_SECRET_KEY: process.env.RECAPTCHA_SECRET_KEY,
    GROQ_API_KEY: process.env.GROQ_API_KEY,
    public: {
      recaptchaSiteKey: process.env.RECAPTCHA_SITE_KEY || "",
      siteUrl: process.env.SITE_URL ?? "http://localhost:3000",
    },
  },

  app: {
    head: {
      title: "Интегро заявки",
      script: [
        {
          src: `https://www.google.com/recaptcha/api.js?render=${process.env.RECAPTCHA_SITE_KEY}`,
          async: true,
          defer: true,
        },
      ],
    },
  },

  plugins: ["~/plugins/recaptcha.client.ts"],

  routeRules: {
    "/**": {
      headers: {
        "X-Frame-Options": "DENY",
        "Content-Security-Policy": "frame-ancestors 'none'",
      },
    },
  },

  nitro: {
    externals: {
      inline: ["@prisma/client"],
      external: [".prisma"],
    },

    rollupConfig: {
      external: ["@prisma/client", ".prisma"],
    },
  },

  vite: {
    resolve: {
      alias: {
        ".prisma/client/index-browser": resolver.resolve(
          "./node_modules/.prisma/client/index-browser.js",
        ),
      },
    },
    optimizeDeps: {
      exclude: ["@prisma/client"],
    },
    ssr: {
      noExternal: ["@prisma/client"],
    },
  },

  build: {
    transpile: ["@prisma/client"],
  },
});
