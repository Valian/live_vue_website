<script setup lang="ts">
import { ref } from "vue"
import { useLiveVue } from "live_vue"

type Message = { id: number; text: string; from: string }

const props = defineProps<{ messages: Message[] }>()

const inputText = ref("")
const live = useLiveVue()

function sendWithPushEvent() {
  if (!inputText.value.trim()) return
  live.pushEvent("add_message", { text: inputText.value })
  inputText.value = ""
}
</script>

<template>
  <div class="p-6 rounded-xl border border-landing-border space-y-6">
    <div class="space-y-3">
      <div class="text-sm font-medium text-landing-muted">Send event with pushEvent()</div>
      <div class="flex gap-2">
        <input
          v-model="inputText"
          type="text"
          placeholder="Type a message..."
          class="flex-1 px-3 py-2 rounded border border-landing-border bg-transparent text-landing-text placeholder:text-landing-muted/50"
          @keyup.enter="sendWithPushEvent"
        />
        <button
          @click="sendWithPushEvent"
          class="px-4 py-2 bg-vue text-white rounded font-medium"
        >
          Send
        </button>
      </div>
    </div>

    <div class="space-y-3">
      <div class="text-sm font-medium text-landing-muted">Send event with phx-click</div>
      <div class="flex gap-2 flex-wrap">
        <button
          phx-click="phx_click_message"
          phx-value-text="Hello!"
          class="px-4 py-2 border border-landing-border rounded hover:bg-white/5 transition-colors"
        >
          Say Hello
        </button>
        <button
          phx-click="phx_click_message"
          phx-value-text="LiveVue rocks!"
          class="px-4 py-2 border border-landing-border rounded hover:bg-white/5 transition-colors"
        >
          LiveVue rocks!
        </button>
        <button
          phx-click="clear"
          class="px-4 py-2 border border-landing-border rounded text-landing-muted hover:bg-white/5 transition-colors"
        >
          Clear
        </button>
      </div>
    </div>

    <div class="space-y-3">
      <div class="flex items-center justify-between">
        <div class="text-sm font-medium text-landing-muted">Messages from server</div>
        <div class="text-xs text-landing-muted/50">{{ props.messages.length }} total</div>
      </div>
      <div class="min-h-[120px] p-4 rounded-lg bg-landing-elevated border border-landing-border">
        <div v-if="props.messages.length === 0" class="text-landing-muted/50 text-sm text-center py-6">
          No messages yet. Send one above!
        </div>
        <div v-else class="space-y-2">
          <div
            v-for="msg in props.messages"
            :key="msg.id"
            class="flex items-center gap-3 text-sm"
          >
            <span
              :class="[
                'px-2 py-0.5 rounded text-xs font-mono',
                msg.from === 'pushEvent'
                  ? 'bg-vue/20 text-vue'
                  : 'bg-phoenix/20 text-phoenix'
              ]"
            >
              {{ msg.from }}
            </span>
            <span class="text-landing-text">{{ msg.text }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
