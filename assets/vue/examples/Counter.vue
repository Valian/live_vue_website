<script setup lang="ts">
import { ref } from "vue"

// Props from LiveView - server state
const props = defineProps<{ count: number }>()

// Local Vue state - no server round-trip
const diff = ref(1)
</script>

<template>
  <div class="p-6 bg-landing-card border border-landing-border rounded-xl">
    <div class="text-center mb-6">
      <div class="text-sm text-landing-muted mb-2">Current count</div>
      <div class="text-5xl font-mono font-bold text-landing-text">
        {{ props.count }}
      </div>
    </div>

    <div class="mb-6">
      <label class="flex items-center justify-between text-sm text-landing-muted mb-2">
        <span>Increment by</span>
        <span class="font-mono text-vue">{{ diff }}</span>
      </label>
      <input
        v-model.number="diff"
        type="range"
        min="1"
        max="10"
        class="w-full h-2 bg-landing-elevated rounded-lg appearance-none cursor-pointer accent-vue"
      />
    </div>

    <div class="flex gap-3">
      <button
        phx-click="dec"
        class="flex-1 py-2.5 px-4 bg-landing-elevated border border-landing-border rounded-lg text-landing-text font-medium transition-all hover:bg-landing-card hover:border-landing-muted"
      >
        −1
      </button>
      <button
        phx-click="inc"
        :phx-value-diff="diff"
        class="flex-1 py-2.5 px-4 bg-phoenix text-white rounded-lg font-medium transition-all hover:bg-phoenix-glow shadow-lg shadow-phoenix/20"
      >
        +{{ diff }}
      </button>
      <button
        phx-click="reset"
        class="py-2.5 px-4 bg-landing-elevated border border-landing-border rounded-lg text-landing-muted font-medium transition-all hover:bg-landing-card hover:border-landing-muted hover:text-landing-text"
      >
        Reset
      </button>
    </div>
  </div>
</template>
