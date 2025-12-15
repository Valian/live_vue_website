<script setup lang="ts">
import { computed } from 'vue'

const props = defineProps<{
  label: string
  labelPosition?: 'left' | 'right'
  highlighted: boolean
  dotProgress: number | null // null = no dot, 0-1 = position (0=top, 1=bottom)
  accentColor: 'phoenix' | 'vue'
}>()

const dotStyle = computed(() => {
  if (props.dotProgress === null) return null
  return { top: `${props.dotProgress * 100}%` }
})

const colorClasses = computed(() => {
  if (!props.highlighted) return ''
  return props.accentColor === 'phoenix'
    ? 'bg-phoenix shadow-[0_0_8px_rgba(253,79,0,0.4)]'
    : 'bg-vue shadow-[0_0_8px_rgba(66,184,131,0.4)]'
})

const labelColorClasses = computed(() => {
  if (!props.highlighted) return ''
  return props.accentColor === 'phoenix'
    ? 'text-phoenix border-phoenix shadow-[0_0_10px_rgba(253,79,0,0.4)]'
    : 'text-vue border-vue shadow-[0_0_10px_rgba(66,184,131,0.4)]'
})

const dotColorClasses = computed(() => {
  return props.accentColor === 'phoenix'
    ? 'bg-phoenix shadow-[0_0_10px_var(--color-phoenix),0_0_20px_var(--color-phoenix)]'
    : 'bg-vue shadow-[0_0_10px_var(--color-vue),0_0_20px_var(--color-vue)]'
})
</script>

<template>
  <div class="relative h-11 flex justify-center items-center">
    <div
      class="w-0.5 h-full bg-white/[0.08] transition-all duration-400"
      :class="colorClasses"
    />
    <div
      v-if="dotStyle"
      class="absolute w-2.5 h-2.5 rounded-full left-1/2 -translate-x-1/2 -translate-y-1/2 z-10"
      :class="dotColorClasses"
      :style="dotStyle"
    />
    <div
      class="absolute flex items-center gap-1.5 py-1 px-2.5 bg-[rgba(10,10,15,0.95)] border border-white/[0.08] rounded text-[0.65rem] uppercase tracking-wide text-[#6a6a80] transition-all duration-400"
      :class="[
        labelColorClasses,
        labelPosition === 'left' ? 'right-[calc(50%+15px)]' : 'left-[calc(50%+15px)]'
      ]"
    >
      <span>{{ label }}</span>
      <svg class="w-2.5 h-2.5" viewBox="0 0 12 12">
        <path d="M6 0 L6 10 M2 6 L6 10 L10 6" stroke="currentColor" fill="none" stroke-width="2"/>
      </svg>
    </div>
  </div>
</template>
