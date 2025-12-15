<script setup lang="ts">
import { useSlots, computed } from 'vue'

const props = defineProps<{
  title?: string
  variant?: 'default' | 'primary' | 'success'
}>()

const slots = useSlots()
const hasHeader = computed(() => !!slots.header)
const hasFooter = computed(() => !!slots.footer)
const hasIcon = computed(() => !!slots.icon)

const variantClasses = computed(() => {
  switch (props.variant) {
    case 'primary':
      return 'border-phoenix/30 bg-phoenix/5'
    case 'success':
      return 'border-vue/30 bg-vue/5'
    default:
      return 'border-landing-border'
  }
})
</script>

<template>
  <div :class="['rounded-xl border overflow-hidden', variantClasses]">
    <!-- Header slot -->
    <div
      v-if="hasHeader || props.title"
      class="px-6 py-4 bg-landing-elevated border-b border-landing-border"
    >
      <div class="flex items-center gap-3">
        <div v-if="hasIcon" class="text-landing-muted">
          <slot name="icon" />
        </div>
        <div class="flex-1">
          <slot name="header">
            <h3 v-if="props.title" class="font-medium text-landing-text">{{ props.title }}</h3>
          </slot>
        </div>
      </div>
    </div>

    <!-- Default slot (main content) -->
    <div class="p-6">
      <slot>
        <p class="text-landing-muted italic">No content provided</p>
      </slot>
    </div>

    <!-- Footer slot -->
    <div
      v-if="hasFooter"
      class="px-6 py-4 bg-landing-elevated border-t border-landing-border"
    >
      <slot name="footer" />
    </div>
  </div>
</template>
