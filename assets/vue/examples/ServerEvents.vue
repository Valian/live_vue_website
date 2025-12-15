<script setup lang="ts">
import { ref } from "vue"
import { useLiveVue, useLiveEvent } from "live_vue"

type Notification = {
  id: number
  type: string
  message: string
  timestamp: number
}

type Alert = {
  id: number
  message: string
  timestamp: number
}

const props = defineProps<{ notificationCount: number }>()

const notifications = ref<Notification[]>([])
const alerts = ref<Alert[]>([])
const live = useLiveVue()

useLiveEvent("notification", (data: Notification) => {
  notifications.value = [data, ...notifications.value].slice(0, 5)
})

useLiveEvent("alert", (data: Alert) => {
  alerts.value = [data, ...alerts.value].slice(0, 3)
})

function triggerNotification(type: string) {
  live.pushEvent("trigger_notification", { type })
}

function triggerAlert(message: string) {
  live.pushEvent("trigger_alert", { message })
}

function getNotificationColor(type: string) {
  const colors: Record<string, string> = {
    info: "bg-blue-500/10 text-blue-500 border-blue-500/20",
    success: "bg-green-500/10 text-green-500 border-green-500/20",
    warning: "bg-yellow-500/10 text-yellow-500 border-yellow-500/20",
    error: "bg-red-500/10 text-red-500 border-red-500/20"
  }
  return colors[type] || colors.info
}
</script>

<template>
  <div class="p-6 rounded-xl border border-landing-border space-y-6">
    <div class="space-y-3">
      <div class="text-sm font-medium text-landing-muted">Trigger server notifications</div>
      <div class="flex gap-2 flex-wrap">
        <button
          @click="triggerNotification('info')"
          class="px-4 py-2 border border-blue-500/20 bg-blue-500/10 text-blue-500 rounded hover:bg-blue-500/20 transition-colors"
        >
          Info
        </button>
        <button
          @click="triggerNotification('success')"
          class="px-4 py-2 border border-green-500/20 bg-green-500/10 text-green-500 rounded hover:bg-green-500/20 transition-colors"
        >
          Success
        </button>
        <button
          @click="triggerNotification('warning')"
          class="px-4 py-2 border border-yellow-500/20 bg-yellow-500/10 text-yellow-500 rounded hover:bg-yellow-500/20 transition-colors"
        >
          Warning
        </button>
        <button
          @click="triggerNotification('error')"
          class="px-4 py-2 border border-red-500/20 bg-red-500/10 text-red-500 rounded hover:bg-red-500/20 transition-colors"
        >
          Error
        </button>
      </div>
    </div>

    <div class="space-y-3">
      <div class="text-sm font-medium text-landing-muted">Trigger server alerts</div>
      <div class="flex gap-2 flex-wrap">
        <button
          @click="triggerAlert('Your session will expire soon')"
          class="px-4 py-2 border border-landing-border rounded hover:bg-white/5 transition-colors"
        >
          Session Alert
        </button>
        <button
          @click="triggerAlert('New message received')"
          class="px-4 py-2 border border-landing-border rounded hover:bg-white/5 transition-colors"
        >
          Message Alert
        </button>
      </div>
    </div>

    <div class="grid grid-cols-2 gap-4 max-sm:grid-cols-1">
      <div class="space-y-3">
        <div class="flex items-center justify-between">
          <div class="text-sm font-medium text-landing-muted">Notifications</div>
          <div class="text-xs text-landing-muted/50">
            {{ props.notificationCount }} total
          </div>
        </div>
        <div class="min-h-[200px] p-4 rounded-lg bg-landing-elevated border border-landing-border">
          <div v-if="notifications.length === 0" class="text-landing-muted/50 text-sm text-center py-8">
            No notifications yet
          </div>
          <div v-else class="space-y-2">
            <div
              v-for="notif in notifications"
              :key="notif.id"
              :class="[
                'p-3 rounded-lg border text-sm',
                getNotificationColor(notif.type)
              ]"
            >
              <div class="flex items-start justify-between gap-2">
                <div class="flex-1">
                  <div class="font-medium capitalize mb-1">{{ notif.type }}</div>
                  <div class="text-xs opacity-80">{{ notif.message }}</div>
                </div>
                <div class="text-xs opacity-50 shrink-0">
                  {{ new Date(notif.timestamp * 1000).toLocaleTimeString() }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="space-y-3">
        <div class="flex items-center justify-between">
          <div class="text-sm font-medium text-landing-muted">Alerts</div>
          <div class="text-xs text-landing-muted/50">Recent 3</div>
        </div>
        <div class="min-h-[200px] p-4 rounded-lg bg-landing-elevated border border-landing-border">
          <div v-if="alerts.length === 0" class="text-landing-muted/50 text-sm text-center py-8">
            No alerts yet
          </div>
          <div v-else class="space-y-2">
            <div
              v-for="alert in alerts"
              :key="alert.id"
              class="p-3 rounded-lg border border-landing-border bg-landing-card text-sm"
            >
              <div class="flex items-start justify-between gap-2">
                <div class="flex-1 text-landing-text">{{ alert.message }}</div>
                <div class="text-xs text-landing-muted/50 shrink-0">
                  {{ new Date(alert.timestamp * 1000).toLocaleTimeString() }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
