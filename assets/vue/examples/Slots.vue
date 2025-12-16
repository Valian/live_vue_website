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
      return 'border-secondary/30 bg-secondary/5'
    case 'success':
      return 'border-primary/30 bg-primary/5'
    default:
      return 'border-base-300'
  }
})
</script>

<template>
  <div :class="['card overflow-hidden', variantClasses]">
    <!-- Header slot -->
    <div
      v-if="hasHeader || props.title"
      class="px-6 py-4 bg-base-200 border-b border-base-300"
    >
      <div class="flex items-center gap-3">
        <div v-if="hasIcon" class="text-neutral">
          <slot name="icon" />
        </div>
        <div class="flex-1">
          <slot name="header">
            <h3 v-if="props.title" class="font-medium">{{ props.title }}</h3>
          </slot>
        </div>
      </div>
    </div>

    <!-- Default slot (main content) -->
    <div class="p-6">
      <slot>
        <p class="text-neutral italic">No content provided</p>
      </slot>
    </div>

    <!-- Footer slot -->
    <div
      v-if="hasFooter"
      class="px-6 py-4 bg-base-200 border-t border-base-300"
    >
      <slot name="footer" />
    </div>
  </div>
</template>
