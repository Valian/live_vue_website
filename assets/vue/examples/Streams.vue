<script setup lang="ts">
import { ref, nextTick, watch } from "vue"

type Message = {
  id: string
  role: "user" | "assistant"
  content: string
}

const props = defineProps<{
  messages: Message[]
  isThinking: boolean
}>()

const input = ref("")
const messagesContainer = ref<HTMLElement>()

function scrollToBottom() {
  nextTick(() => {
    if (messagesContainer.value) {
      messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
    }
  })
}

watch(() => props.messages.length, scrollToBottom)
watch(() => props.isThinking, scrollToBottom)
</script>

<template>
  <div class="flex flex-col h-96 rounded-xl border border-landing-border">
    <div
      ref="messagesContainer"
      class="flex-1 overflow-y-auto p-4 space-y-3"
    >
      <div
        v-for="message in messages"
        :key="message.id"
        :class="[
          'max-w-[80%] p-3 rounded-lg',
          message.role === 'user'
            ? 'ml-auto bg-phoenix text-white'
            : 'mr-auto bg-landing-elevated text-landing-text'
        ]"
      >
        {{ message.content }}
      </div>

      <div v-if="isThinking" class="max-w-[80%] mr-auto p-3 rounded-lg bg-landing-elevated">
        <div class="flex items-center gap-1.5">
          <div class="w-2 h-2 rounded-full bg-landing-muted animate-bounce [animation-delay:-0.3s]"></div>
          <div class="w-2 h-2 rounded-full bg-landing-muted animate-bounce [animation-delay:-0.15s]"></div>
          <div class="w-2 h-2 rounded-full bg-landing-muted animate-bounce"></div>
        </div>
      </div>
    </div>

    <form
      phx-submit="send_message"
      class="p-3 border-t border-landing-border flex gap-2"
    >
      <input
        v-model="input"
        name="content"
        type="text"
        placeholder="Type a message..."
        :disabled="isThinking"
        class="flex-1 px-3 py-2 bg-landing-elevated border border-landing-border rounded-lg text-sm placeholder:text-landing-muted disabled:opacity-50"
      />
      <button
        type="submit"
        :disabled="isThinking || !input.trim()"
        class="px-4 py-2 bg-phoenix text-white rounded-lg text-sm font-medium disabled:opacity-50"
      >
        Send
      </button>
    </form>
  </div>
</template>
