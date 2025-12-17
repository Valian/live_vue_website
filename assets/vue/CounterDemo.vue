<script setup lang="ts">
import { ref } from 'vue'
import { useLiveVue } from 'live_vue'

const props = defineProps<{
  count: number
}>()

const live = useLiveVue()

// Local Vue state - doesn't hit the server
const diff = ref(1)
const lastAction = ref<string | null>(null)
let actionTimeout: ReturnType<typeof setTimeout> | null = null

function showAction(action: string) {
  lastAction.value = action
  if (actionTimeout) {
    clearTimeout(actionTimeout)
  }
  actionTimeout = setTimeout(() => {
    lastAction.value = null
    actionTimeout = null
  }, 1500)
}

function increment() {
  live.pushEvent('inc', { diff: diff.value })
  showAction(`+${diff.value}`)
}

function decrement() {
  live.pushEvent('dec', {})
  showAction('-1')
}

function reset() {
  live.pushEvent('reset', {})
  showAction('reset')
}
</script>

<template>
  <div class="flex flex-col gap-6 p-8 bg-[rgba(15,15,21,0.9)] border border-white/10 rounded-2xl backdrop-blur-xl min-w-[320px] max-w-[380px]">
    <!-- Display Section -->
    <div class="text-center py-8 px-4 bg-[linear-gradient(135deg,rgba(253,79,0,0.05)_0%,rgba(66,184,131,0.05)_100%)] border border-white/10 rounded-xl">
      <div class="font-mono text-xs uppercase tracking-widest text-phoenix mb-2">
        Server State
      </div>
      <div
        class="font-serif text-[5rem] font-normal leading-none text-landing-text transition-all duration-200 animate-[count-pop_0.3s_ease-out]"
        :key="count"
      >
        {{ count }}
      </div>
      <div class="font-mono text-xs text-landing-muted mt-3">
        @count from LiveView assigns
      </div>
    </div>

    <!-- Controls Section -->
    <div class="flex flex-col gap-5">
      <div class="flex flex-col gap-2">
        <label class="flex justify-between items-center text-[0.85rem] text-landing-text">
          <span>Increment by:</span>
          <span class="font-mono font-semibold text-vue bg-vue/10 py-0.5 px-2 rounded">{{ diff }}</span>
        </label>
        <input
          id="increment-diff"
          v-model.number="diff"
          type="range"
          min="1"
          max="10"
          aria-label="Increment amount"
          class="w-full h-1.5 bg-[rgba(26,26,36,0.9)] rounded-sm outline-none cursor-pointer appearance-none [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:w-5 [&::-webkit-slider-thumb]:h-5 [&::-webkit-slider-thumb]:bg-vue [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:cursor-pointer [&::-webkit-slider-thumb]:shadow-[0_2px_8px_rgba(66,184,131,0.3)] [&::-webkit-slider-thumb]:transition-all [&::-webkit-slider-thumb]:duration-200 hover:[&::-webkit-slider-thumb]:scale-115 hover:[&::-webkit-slider-thumb]:shadow-[0_4px_16px_rgba(66,184,131,0.3)] [&::-moz-range-thumb]:w-5 [&::-moz-range-thumb]:h-5 [&::-moz-range-thumb]:bg-vue [&::-moz-range-thumb]:border-none [&::-moz-range-thumb]:rounded-full [&::-moz-range-thumb]:cursor-pointer [&::-moz-range-thumb]:shadow-[0_2px_8px_rgba(66,184,131,0.3)]"
        />
        <div class="font-mono text-xs text-landing-muted text-center">
          Local Vue state — no server round-trip
        </div>
      </div>

      <!-- Buttons -->
      <div class="grid grid-cols-3 gap-3">
        <button
          class="flex flex-col items-center justify-center gap-1 p-4 border border-phoenix bg-phoenix/10 rounded-[10px] text-landing-text cursor-pointer transition-all duration-150 hover:-translate-y-0.5 hover:bg-phoenix/20 hover:shadow-[0_4px_20px_rgba(253,79,0,0.3)] active:translate-y-0"
          @click="increment"
        >
          <span class="text-2xl font-light leading-none text-phoenix">+</span>
          <span class="font-mono text-xs text-landing-muted">{{ diff }}</span>
        </button>

        <button
          class="flex flex-col items-center justify-center gap-1 p-4 border border-white/10 bg-[rgba(26,26,36,0.9)] rounded-[10px] text-landing-text cursor-pointer transition-all duration-150 hover:-translate-y-0.5 hover:border-landing-muted hover:bg-white/5 active:translate-y-0"
          @click="decrement"
        >
          <span class="text-2xl font-light leading-none">−</span>
          <span class="font-mono text-xs text-landing-muted">1</span>
        </button>

        <button
          class="flex flex-col items-center justify-center gap-1 p-4 border border-white/10 bg-[rgba(26,26,36,0.9)] rounded-[10px] text-landing-text text-xs cursor-pointer transition-all duration-150 hover:-translate-y-0.5 hover:border-landing-muted hover:bg-white/5 active:translate-y-0"
          @click="reset"
        >
          <span class="font-mono text-xs text-landing-text">Reset</span>
        </button>
      </div>

      <!-- Action Hint - fixed height to prevent layout shift -->
      <div class="h-12">
        <div
          v-if="lastAction"
          class="flex items-center gap-2 py-3 px-4 bg-phoenix/10 border border-phoenix/20 rounded-lg text-xs text-landing-muted"
        >
          <span class="font-mono text-xs uppercase tracking-wide py-0.5 px-1.5 bg-phoenix text-white rounded font-semibold">
            event
          </span>
          {{ lastAction === 'reset' ? 'Sent "reset"' : `Sent "inc" with diff=${lastAction?.replace('+', '')}` }}
        </div>
      </div>
    </div>
  </div>
</template>
