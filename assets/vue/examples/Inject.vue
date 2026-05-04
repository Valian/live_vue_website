<script setup lang="ts">
defineProps<{
  message: string
}>()
</script>

<template>
  <div class="space-y-3">
    <p class="text-sm font-medium">{{ message }}</p>
    <p class="text-xs text-neutral">
      This component is <strong>injected</strong> into the layout's
      default slot via <code class="bg-base-300 px-1 py-0.5 rounded">v-inject</code>.
    </p>
    <button
      phx-click="change_message"
      class="btn btn-sm btn-secondary"
    >
      Change message
    </button>
  </div>
</template>
