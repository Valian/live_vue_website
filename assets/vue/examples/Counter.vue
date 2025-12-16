<script setup lang="ts">
import { ref } from "vue"

const props = defineProps<{ count: number }>()
const diff = ref(1)
</script>

<template>
  <div class="card bg-base-200 p-6">
    <div class="text-center mb-6">
      <div class="text-sm text-neutral mb-2">Count</div>
      <Transition name="count" mode="out-in">
        <div :key="props.count" class="text-5xl font-mono font-bold">
          {{ props.count }}
        </div>
      </Transition>
    </div>

    <div class="mb-6">
      <label class="flex justify-between text-sm text-neutral mb-2">
        <span>Step</span>
        <span class="font-mono text-primary">{{ diff }}</span>
      </label>
      <input
        v-model.number="diff"
        type="range"
        min="1"
        max="10"
        class="range range-primary range-sm"
      />
    </div>

    <div class="flex gap-2">
      <button phx-click="inc" :phx-value-diff="-diff" class="btn btn-outline flex-1">
        −{{ diff }}
      </button>
      <button phx-click="inc" :phx-value-diff="diff" class="btn btn-secondary flex-1">
        +{{ diff }}
      </button>
      <button phx-click="reset" class="btn btn-ghost text-neutral">
        Reset
      </button>
    </div>
  </div>
</template>

<style scoped>
.count-enter-active,
.count-leave-active {
  transition: all 0.15s ease;
}

.count-enter-from {
  opacity: 0;
  transform: translateY(-8px);
}

.count-leave-to {
  opacity: 0;
  transform: translateY(8px);
}
</style>
