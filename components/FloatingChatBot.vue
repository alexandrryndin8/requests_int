<script setup lang="ts">
import { marked } from "marked";
import DOMPurify from "dompurify";

type ChatMessage = {
  role: "user" | "assistant";
  text: string;
  html?: string;
};

type ChatApiMessage = {
  role: "user" | "assistant";
  content: string;
};

type ChatApiResponse = {
  choices?: Array<{
    message?: {
      content?: string;
    };
  }>;
};

const isOpen = ref(false);
const message = ref("");
const isLoading = ref(false);
const errorText = ref("");
const maxHistoryMessages = 10;
const { selectedLanguage } = useSiteLanguage();

const translations = {
  ru: {
    title: "Чат с ассистентом",
    initialMessage:
      "Здравствуйте! Я ИИ помощник компании. Могу ответить на часто задаваемые вопросы.",
    placeholder: "Напишите вопрос...",
    closeChat: "Закрыть чат",
    openChat: "Открыть чат",
  },
  kk: {
    title: "Ассистентпен чат",
    initialMessage:
      "Сәлеметсіз бе! Мен компанияның ИИ көмекшісімін. Жиі қойылатын сұрақтарға жауап бере аламын.",
    placeholder: "Сұрағыңызды жазыңыз...",
    closeChat: "Чатты жабу",
    openChat: "Чатты ашу",
  },
};

const t = computed(() => translations[selectedLanguage.value]);

const messages = ref<ChatMessage[]>([
  {
    role: "assistant",
    text: t.value.initialMessage,
  },
]);

const chatHistory = ref<ChatApiMessage[]>([]);

const canSend = computed(
  () => message.value.trim().length > 0 && !isLoading.value,
);

const toggleChat = () => {
  isOpen.value = !isOpen.value;
  errorText.value = "";
};

const closeChat = () => {
  isOpen.value = false;
};

watch(selectedLanguage, () => {
  if (messages.value.length === 1 && messages.value[0]?.role === "assistant") {
    messages.value[0].text = t.value.initialMessage;
  }
});

const renderMarkdown = (text: string) => {
  const rawHtml = marked.parse(text, { breaks: true, async: false }) as string;
  return DOMPurify.sanitize(rawHtml);
};

const generateBotResponse = async (userMessage: string) => {
  chatHistory.value.push({
    role: "user",
    content: userMessage,
  });

  const requestMessages = chatHistory.value.slice(-maxHistoryMessages);

  const data = await $fetch<ChatApiResponse>("/api/chat", {
    method: "POST",
    body: {
      messages: requestMessages,
    },
  });

  const apiResponseText = data.choices?.[0]?.message?.content;

  if (!apiResponseText) {
    throw new Error("Бот вернул пустой ответ.");
  }

  const botText = apiResponseText.trim();

  chatHistory.value.push({
    role: "assistant",
    content: botText,
  });

  messages.value.push({
    role: "assistant",
    text: botText,
    html: renderMarkdown(botText),
  });
};

const sendMessage = async () => {
  const userMessage = message.value.trim();

  if (!userMessage || isLoading.value) return;

  messages.value.push({
    role: "user",
    text: userMessage,
  });

  message.value = "";
  errorText.value = "";
  isLoading.value = true;

  try {
    await generateBotResponse(userMessage);
  } catch (error: any) {
    if (error?.status === 429 || error?.statusCode === 429) {
      errorText.value = "Достигнут лимит сообщений. Подождите немного.";
    } else {
      errorText.value =
        error instanceof Error
          ? error.message
          : "Произошла ошибка при отправке сообщения.";
    }
  } finally {
    isLoading.value = false;
  }
};
</script>

<template>
  <section
    class="fixed bottom-5 right-5 z-50 flex flex-col items-end gap-3 max-sm:bottom-4 max-sm:right-4"
  >
    <Transition
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="translate-y-3 opacity-0"
      enter-to-class="translate-y-0 opacity-100"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="translate-y-0 opacity-100"
      leave-to-class="translate-y-3 opacity-0"
    >
      <div
        v-if="isOpen"
        class="flex h-[520px] w-[360px] max-w-[calc(100vw-32px)] flex-col overflow-hidden rounded-lg bg-white shadow-2xl"
      >
        <header
          class="flex items-center justify-between bg-[#1d64d6] px-4 py-3 text-white"
        >
          <div>
            <p class="text-sm font-semibold leading-5">{{ t.title }}</p>
          </div>

          <button
            type="button"
            class="grid h-8 w-8 place-items-center rounded-full text-xl leading-none text-slate-200 transition hover:bg-white/10 hover:text-white"
            :aria-label="t.closeChat"
            @click="closeChat"
          >
            ×
          </button>
        </header>

        <div class="flex-1 space-y-3 overflow-y-auto bg-slate-50 px-4 py-4">
          <div
            v-for="(chatMessage, index) in messages"
            :key="`${chatMessage.role}-${index}`"
            class="flex"
            :class="
              chatMessage.role === 'user' ? 'justify-end' : 'justify-start'
            "
          >
            <p
              v-if="chatMessage.role === 'user'"
              class="max-w-[82%] whitespace-pre-line break-words rounded-lg bg-[#3FB1F3] px-3 py-2 text-sm leading-5 text-white shadow-sm"
            >
              {{ chatMessage.text }}
            </p>
            <div
              v-else
              class="chat-markdown max-w-[82%] break-words rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm leading-5 text-slate-800 shadow-sm"
              v-html="chatMessage.html ?? chatMessage.text"
            />
          </div>

          <div v-if="isLoading" class="flex justify-start">
            <p
              class="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm text-slate-500 shadow-sm"
            >
              Бот печатает...
            </p>
          </div>
        </div>

        <div class="border-t border-slate-200 bg-white p-3">
          <p
            v-if="errorText"
            class="mb-2 rounded-md bg-red-50 px-3 py-2 text-xs text-red-700"
          >
            {{ errorText }}
          </p>

          <form class="flex items-end gap-2" @submit.prevent="sendMessage">
            <textarea
              v-model="message"
              rows="1"
              class="max-h-28 min-h-11 flex-1 resize-none rounded-lg border border-slate-300 px-3 py-2 text-sm text-slate-900 outline-none transition focus:border-[#3FB1F3] focus:ring-2 focus:ring-[#3FB1F3]/20"
              :placeholder="t.placeholder"
              @keydown.enter.exact.prevent="sendMessage"
            />

            <button
              type="submit"
              class="grid h-11 w-11 shrink-0 place-items-center rounded-lg bg-[#3FB1F3] text-white transition hover:bg-[#318fc6] active:scale-95 disabled:cursor-not-allowed disabled:bg-slate-300 disabled:active:scale-100"
              :disabled="!canSend"
              aria-label="Отправить сообщение"
            >
              <span class="text-lg leading-none">➤</span>
            </button>
          </form>
        </div>
      </div>
    </Transition>

    <button
      type="button"
      class="grid h-14 w-14 place-items-center rounded-full bg-[#3FB1F3] text-white shadow-xl transition hover:bg-[#318fc6] active:scale-95"
      :aria-label="isOpen ? t.closeChat : t.openChat"
      @click="toggleChat"
    >
      <span v-if="!isOpen" class="text-2xl leading-none">?</span>
      <span v-else class="text-3xl leading-none">×</span>
    </button>
  </section>
</template>

<style scoped>
.chat-markdown :deep(p) {
  margin: 0 0 0.5em;
}

.chat-markdown :deep(p:last-child) {
  margin-bottom: 0;
}

.chat-markdown :deep(ul),
.chat-markdown :deep(ol) {
  margin: 0 0 0.5em;
  padding-left: 1.25em;
}

.chat-markdown :deep(ul) {
  list-style: disc;
}

.chat-markdown :deep(ol) {
  list-style: decimal;
}

.chat-markdown :deep(li) {
  margin-bottom: 0.15em;
}

.chat-markdown :deep(strong) {
  font-weight: 600;
}

.chat-markdown :deep(a) {
  color: #1d64d6;
  text-decoration: underline;
}

.chat-markdown :deep(code) {
  background: #f1f5f9;
  border-radius: 4px;
  padding: 0.1em 0.35em;
  font-size: 0.85em;
}

.chat-markdown :deep(pre) {
  background: #f1f5f9;
  border-radius: 6px;
  padding: 0.5em;
  overflow-x: auto;
  margin: 0 0 0.5em;
}

.chat-markdown :deep(pre code) {
  background: none;
  padding: 0;
}
</style>
