<script setup lang="ts">
import { ref, onMounted } from "vue"

const isClient = ref(false)
const browserInfo = ref({
  userAgent: "Rendering on server...",
  viewport: "Rendering on server...",
  timestamp: "Rendering on server...",
})

onMounted(() => {
  isClient.value = true
  browserInfo.value = {
    userAgent: navigator.userAgent.substring(0, 80) + "...",
    viewport: `${window.innerWidth}x${window.innerHeight}`,
    timestamp: new Date().toLocaleTimeString(),
  }
})
</script>

<template>
  <div class="space-y-4">
    <div class="flex items-center gap-2 mb-3">
      <div
        :class="[
          'w-3 h-3 rounded-full transition-colors',
          isClient ? 'bg-vue' : 'bg-landing-muted/30'
        ]"
      />
      <span class="text-sm font-medium text-landing-muted">
        {{ isClient ? 'Client-side rendered' : 'Server-side rendered' }}
      </span>
    </div>

    <div class="space-y-3">
      <div class="text-xs text-landing-muted">User Agent:</div>
      <div class="p-3 rounded bg-landing-elevated border border-landing-border font-mono text-xs text-landing-text break-all">
        {{ browserInfo.userAgent }}
      </div>
    </div>

    <div class="grid grid-cols-2 gap-3">
      <div class="space-y-2">
        <div class="text-xs text-landing-muted">Viewport Size:</div>
        <div class="p-3 rounded bg-landing-elevated border border-landing-border font-mono text-sm text-landing-text text-center">
          {{ browserInfo.viewport }}
        </div>
      </div>

      <div class="space-y-2">
        <div class="text-xs text-landing-muted">Hydrated At:</div>
        <div class="p-3 rounded bg-landing-elevated border border-landing-border font-mono text-sm text-landing-text text-center">
          {{ browserInfo.timestamp }}
        </div>
      </div>
    </div>

    <div class="text-xs text-landing-muted/70 italic pt-2">
      {{ isClient
        ? 'This component has been hydrated and can now access browser APIs.'
        : 'This content was rendered on the server without access to window or navigator.'
      }}
    </div>
  </div>
</template>
