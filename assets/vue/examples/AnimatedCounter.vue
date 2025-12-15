<script setup lang="ts">
import { ref, watch } from "vue"

const props = defineProps<{ count: number }>()
const displayCount = ref(props.count)

// Animate the count number when it changes
watch(
  () => props.count,
  (newVal, oldVal) => {
    const duration = 300
    const steps = 20
    const stepDuration = duration / steps
    const increment = (newVal - oldVal) / steps

    let currentStep = 0

    const interval = setInterval(() => {
      currentStep++
      if (currentStep >= steps) {
        displayCount.value = newVal
        clearInterval(interval)
      } else {
        displayCount.value = Math.round(oldVal + increment * currentStep)
      }
    }, stepDuration)
  }
)
</script>

<template>
  <div class="p-6 rounded-xl border border-landing-border">
    <div class="text-center mb-6">
      <div class="text-sm text-landing-muted mb-2">Animated Count</div>
      <Transition name="bounce" mode="out-in">
        <div :key="displayCount" class="text-5xl font-mono font-bold text-vue">
          {{ displayCount }}
        </div>
      </Transition>
    </div>

    <div class="flex gap-2">
      <button
        phx-click="inc"
        class="flex-1 py-2 px-3 border border-landing-border rounded hover:bg-landing-elevated transition-colors"
      >
        −1
      </button>
      <button
        phx-click="inc"
        phx-value-diff="5"
        class="flex-1 py-2 px-3 bg-phoenix text-white rounded hover:bg-phoenix/90 transition-colors"
      >
        +5
      </button>
      <button
        phx-click="reset"
        class="py-2 px-3 border border-landing-border rounded text-landing-muted hover:bg-landing-elevated transition-colors"
      >
        Reset
      </button>
    </div>
  </div>
</template>

<style scoped>
/* Bounce transition */
.bounce-enter-active {
  animation: bounce-in 0.3s;
}

.bounce-leave-active {
  animation: bounce-out 0.2s;
}

@keyframes bounce-in {
  0% {
    transform: scale(0.8);
    opacity: 0;
  }
  50% {
    transform: scale(1.1);
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

@keyframes bounce-out {
  0% {
    transform: scale(1);
    opacity: 1;
  }
  100% {
    transform: scale(0.8);
    opacity: 0;
  }
}
</style>
