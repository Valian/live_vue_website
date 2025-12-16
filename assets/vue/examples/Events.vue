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
  <div class="card bg-base-200 p-6 space-y-6">
    <div class="space-y-3">
      <div class="text-sm font-medium text-neutral">Send event with pushEvent()</div>
      <div class="flex gap-2">
        <input
          v-model="inputText"
          type="text"
          placeholder="Type a message..."
          class="input input-bordered flex-1"
          @keyup.enter="sendWithPushEvent"
        />
        <button @click="sendWithPushEvent" class="btn btn-primary">
          Send
        </button>
      </div>
    </div>

    <div class="space-y-3">
      <div class="text-sm font-medium text-neutral">Send event with phx-click</div>
      <div class="flex gap-2 flex-wrap">
        <button
          phx-click="phx_click_message"
          phx-value-text="Hello!"
          class="btn btn-outline"
        >
          Say Hello
        </button>
        <button
          phx-click="phx_click_message"
          phx-value-text="LiveVue rocks!"
          class="btn btn-outline"
        >
          LiveVue rocks!
        </button>
        <button phx-click="clear" class="btn btn-ghost text-neutral">
          Clear
        </button>
      </div>
    </div>

    <div class="space-y-3">
      <div class="flex items-center justify-between">
        <div class="text-sm font-medium text-neutral">Messages from server</div>
        <div class="text-xs text-neutral/50">{{ props.messages.length }} total</div>
      </div>
      <div class="min-h-[120px] p-4 rounded-lg bg-base-300 border border-base-300">
        <div v-if="props.messages.length === 0" class="text-neutral/50 text-sm text-center py-6">
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
                'badge font-mono',
                msg.from === 'pushEvent'
                  ? 'badge-primary badge-outline'
                  : 'badge-secondary badge-outline'
              ]"
            >
              {{ msg.from }}
            </span>
            <span>{{ msg.text }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
