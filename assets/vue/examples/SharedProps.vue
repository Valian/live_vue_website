<script setup lang="ts">
import { computed } from 'vue'
import { useLiveVue } from 'live_vue'

defineProps<{
  pageTitle: string
}>()

const shared = useLiveVue("shared-state")

const user = computed(() => shared?.vue.props.user)
const theme = computed(() => shared?.vue.props.theme)
</script>

<template>
  <div
    class="rounded-xl border overflow-hidden transition-colors duration-300"
    :class="theme === 'dark'
      ? 'bg-base-300 border-base-content/20'
      : 'bg-base-100 border-base-300'"
  >
    <div
      class="px-4 py-3 border-b flex items-center justify-between transition-colors duration-300"
      :class="theme === 'dark'
        ? 'border-base-content/20 bg-base-content/5'
        : 'border-base-300 bg-base-200'"
    >
      <span class="text-sm font-medium">{{ pageTitle }}</span>
      <span class="text-xs px-2 py-0.5 rounded-full bg-secondary/20 text-secondary">
        {{ theme }}
      </span>
    </div>

    <div class="p-6 space-y-4">
      <div v-if="user" class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-full bg-primary/20 flex items-center justify-center text-primary text-sm font-bold">
          {{ user.name.charAt(0) }}
        </div>
        <div>
          <p class="text-sm font-medium">{{ user.name }}</p>
          <p class="text-xs text-neutral">{{ user.role }}</p>
        </div>
      </div>

      <p class="text-xs text-neutral">
        User and theme are read from a <strong>headless</strong> component
        via <code class="bg-base-300 px-1 py-0.5 rounded">useLiveVue("shared-state")</code>.
        No props passed directly — all shared state comes from the headless provider.
      </p>
    </div>
  </div>
</template>
