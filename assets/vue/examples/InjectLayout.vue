<script setup lang="ts">
defineProps<{
  title: string
  theme: string
}>()
</script>

<template>
  <div
    class="rounded-xl border overflow-hidden transition-colors duration-300"
    :class="theme === 'dark'
      ? 'bg-base-300 border-base-content/20'
      : 'bg-base-100 border-base-300'"
  >
    <!-- Layout header -->
    <div
      class="px-4 py-3 border-b flex items-center justify-between transition-colors duration-300"
      :class="theme === 'dark'
        ? 'border-base-content/20 bg-base-content/5'
        : 'border-base-300 bg-base-200'"
    >
      <div class="flex items-center gap-2">
        <div class="w-2.5 h-2.5 rounded-full bg-error"></div>
        <div class="w-2.5 h-2.5 rounded-full bg-warning"></div>
        <div class="w-2.5 h-2.5 rounded-full bg-success"></div>
      </div>
      <span class="text-sm font-medium">{{ title }}</span>
      <span class="text-xs px-2 py-0.5 rounded-full bg-secondary/20 text-secondary">
        {{ theme }}
      </span>
    </div>

    <!-- Slot for injected page content -->
    <div class="p-6">
      <slot>
        <p class="text-neutral italic text-sm">No page injected</p>
      </slot>
    </div>
  </div>
</template>
