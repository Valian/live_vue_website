<script setup lang="ts">
import { useLiveConnection } from 'live_vue'
import { ref, watch } from 'vue'

interface StateHistoryEntry {
  state: string
  timestamp: Date
}

const { connectionState, isConnected } = useLiveConnection()

// Track state history for demo purposes
const stateHistory = ref<StateHistoryEntry[]>([])

watch(connectionState, (newState) => {
  stateHistory.value.push({
    state: newState,
    timestamp: new Date()
  })
  // Keep last 5 entries
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

const getStateColor = (state: string) => {
  switch (state) {
    case 'open':
      return 'text-green-500'
    case 'connecting':
      return 'text-amber-500'
    case 'closing':
      return 'text-orange-500'
    case 'closed':
      return 'text-red-500'
    default:
      return 'text-landing-muted'
  }
}

const getStateBgColor = (state: string) => {
  switch (state) {
    case 'open':
      return 'bg-green-500/10'
    case 'connecting':
      return 'bg-amber-500/10'
    case 'closing':
      return 'bg-orange-500/10'
    case 'closed':
      return 'bg-red-500/10'
    default:
      return 'bg-landing-card'
  }
}

const getStateDotColor = (state: string) => {
  switch (state) {
    case 'open':
      return 'bg-green-500'
    case 'connecting':
      return 'bg-amber-500'
    case 'closing':
      return 'bg-orange-500'
    case 'closed':
      return 'bg-red-500'
    default:
      return 'bg-landing-muted'
  }
}
</script>

<template>
  <div class="p-6 rounded-xl border border-landing-border space-y-6">
    <!-- Current status display -->
    <div class="text-center">
      <div class="text-sm text-landing-muted mb-3">WebSocket Connection</div>
      <div
        class="inline-flex items-center gap-3 px-6 py-3 rounded-full transition-colors"
        :class="getStateBgColor(connectionState)"
      >
        <span
          class="w-3 h-3 rounded-full transition-colors"
          :class="[
            getStateDotColor(connectionState),
            isConnected ? 'animate-pulse' : ''
          ]"
        />
        <span class="font-mono text-lg transition-colors" :class="getStateColor(connectionState)">
          {{ connectionState }}
        </span>
      </div>
      <div class="mt-3 text-sm" :class="isConnected ? 'text-green-500/80' : 'text-landing-muted'">
        {{ isConnected ? 'Connected' : 'Disconnected' }}
      </div>
    </div>

    <!-- State history -->
    <div v-if="stateHistory.length > 0" class="pt-4 border-t border-landing-border">
      <div class="text-sm text-landing-muted mb-3">Connection History</div>
      <div class="space-y-2">
        <div
          v-for="(entry, index) in stateHistory.slice().reverse()"
          :key="index"
          class="flex items-center justify-between py-2 px-3 rounded border border-landing-border/50 text-sm"
        >
          <div class="flex items-center gap-2">
            <span
              class="w-2 h-2 rounded-full"
              :class="getStateDotColor(entry.state)"
            />
            <span class="font-mono" :class="getStateColor(entry.state)">
              {{ entry.state }}
            </span>
          </div>
          <span class="text-xs text-landing-muted font-mono">
            {{ formatTime(entry.timestamp) }}
          </span>
        </div>
      </div>
    </div>

    <!-- Info note -->
    <div class="pt-4 border-t border-landing-border text-xs text-landing-muted">
      Open your browser's DevTools and throttle the network to see state changes, or navigate away and back.
    </div>
  </div>
</template>
