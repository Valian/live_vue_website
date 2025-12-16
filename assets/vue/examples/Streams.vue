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
  <div class="card bg-base-200 flex flex-col h-96">
    <div ref="messagesContainer" class="flex-1 overflow-y-auto p-4 space-y-3">
      <div
        v-for="message in messages"
        :key="message.id"
        :class="[
          'max-w-[80%] p-3 rounded-lg',
          message.role === 'user'
            ? 'ml-auto bg-secondary text-white'
            : 'mr-auto bg-base-300'
        ]"
      >
        {{ message.content }}
      </div>

      <div v-if="isThinking" class="max-w-[80%] mr-auto p-3 rounded-lg bg-base-300">
        <div class="flex items-center gap-1.5">
          <div class="w-2 h-2 rounded-full bg-neutral animate-bounce [animation-delay:-0.3s]"></div>
          <div class="w-2 h-2 rounded-full bg-neutral animate-bounce [animation-delay:-0.15s]"></div>
          <div class="w-2 h-2 rounded-full bg-neutral animate-bounce"></div>
        </div>
      </div>
    </div>

    <form phx-submit="send_message" class="p-3 border-t border-base-300 flex gap-2">
      <input
        v-model="input"
        name="content"
        type="text"
        placeholder="Type a message..."
        :disabled="isThinking"
        class="input input-bordered flex-1 text-sm"
      />
      <button
        type="submit"
        :disabled="isThinking || !input.trim()"
        class="btn btn-secondary btn-sm"
      >
        Send
      </button>
    </form>
  </div>
</template>
