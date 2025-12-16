<script setup lang="ts">
import { useLiveConnection } from 'live_vue'
import { ref, watch } from 'vue'

interface StateHistoryEntry {
  state: string
  timestamp: Date
}

const { connectionState, isConnected } = useLiveConnection()

const stateHistory = ref<StateHistoryEntry[]>([])

watch(connectionState, (newState) => {
  stateHistory.value.push({
    state: newState,
    timestamp: new Date()
  })
  if (stateHistory.value.length > 5) {
    stateHistory.value.shift()
  }
}, { immediate: true })

const formatTime = (date: Date) => {
  return date.toLocaleTimeString('en-US', {
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    fractionalSecondDigits: 3
  })
}

const getStateClass = (state: string) => {
  switch (state) {
    case 'open':
      return 'text-success'
    case 'connecting':
      return 'text-warning'
    case 'closing':
      return 'text-warning'
    case 'closed':
      return 'text-error'
    default:
      return 'text-neutral'
  }
}

const getStateBadge = (state: string) => {
  switch (state) {
    case 'open':
      return 'badge-success'
    case 'connecting':
      return 'badge-warning'
    case 'closing':
      return 'badge-warning'
    case 'closed':
      return 'badge-error'
    default:
      return 'badge-ghost'
  }
}
</script>

<template>
  <div class="card bg-base-200 p-6 space-y-6">
    <div class="text-center">
      <div class="text-sm text-neutral mb-3">WebSocket Connection</div>
      <div class="inline-flex items-center gap-3">
        <span
          :class="[
            'badge badge-lg gap-2',
            getStateBadge(connectionState),
            isConnected && 'animate-pulse'
          ]"
        >
          <span class="w-2 h-2 rounded-full bg-current" />
          <span class="font-mono">{{ connectionState }}</span>
        </span>
      </div>
      <div class="mt-3 text-sm" :class="isConnected ? 'text-success' : 'text-neutral'">
        {{ isConnected ? 'Connected' : 'Disconnected' }}
      </div>
    </div>

    <div v-if="stateHistory.length > 0" class="pt-4 border-t border-base-300">
      <div class="text-sm text-neutral mb-3">Connection History</div>
      <div class="space-y-2">
        <div
          v-for="(entry, index) in stateHistory.slice().reverse()"
          :key="index"
          class="flex items-center justify-between py-2 px-3 rounded border border-base-300 text-sm"
        >
          <span :class="['badge badge-sm gap-1.5', getStateBadge(entry.state)]">
            <span class="w-1.5 h-1.5 rounded-full bg-current" />
            <span class="font-mono">{{ entry.state }}</span>
          </span>
          <span class="text-xs text-neutral font-mono">
            {{ formatTime(entry.timestamp) }}
          </span>
        </div>
      </div>
    </div>

    <div class="pt-4 border-t border-base-300 text-xs text-neutral">
      Open your browser's DevTools and throttle the network to see state changes, or navigate away and back.
    </div>
  </div>
</template>
