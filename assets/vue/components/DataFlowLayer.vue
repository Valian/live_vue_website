<script setup lang="ts">
defineProps<{
  badge: string
  title: string
  highlighted: boolean
  accentColor: 'phoenix' | 'vue'
}>()
</script>

<template>
  <div
    class="p-4 px-5 rounded-[10px] border border-white/[0.08] bg-[rgba(20,20,28,0.9)] transition-all duration-400 relative"
    :class="{
      'border-phoenix shadow-[0_0_25px_rgba(253,79,0,0.4),inset_0_0_20px_rgba(253,79,0,0.05)]': highlighted && accentColor === 'phoenix',
      'border-vue shadow-[0_0_25px_rgba(66,184,131,0.4),inset_0_0_20px_rgba(66,184,131,0.05)]': highlighted && accentColor === 'vue'
    }"
  >
    <div class="absolute -top-2 right-3 text-[0.6rem] uppercase tracking-widest py-0.5 px-2 rounded bg-[rgba(10,10,15,0.95)] border border-white/[0.08] text-[#6a6a80]">
      {{ badge }}
    </div>
    <div class="flex items-center gap-2 text-xs font-semibold text-landing-text mb-3">
      <slot name="icon" />
      {{ title }}
    </div>
    <slot />
  </div>
</template>
