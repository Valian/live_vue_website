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
    info: "badge-info",
    success: "badge-success",
    warning: "badge-warning",
    error: "badge-error"
  }
  return colors[type] || colors.info
}
</script>

<template>
  <div class="card bg-base-200 p-6 space-y-6">
    <div class="space-y-3">
      <div class="text-sm font-medium text-neutral">Trigger server notifications</div>
      <div class="flex gap-2 flex-wrap">
        <button @click="triggerNotification('info')" class="btn btn-info btn-sm">
          Info
        </button>
        <button @click="triggerNotification('success')" class="btn btn-success btn-sm">
          Success
        </button>
        <button @click="triggerNotification('warning')" class="btn btn-warning btn-sm">
          Warning
        </button>
        <button @click="triggerNotification('error')" class="btn btn-error btn-sm">
          Error
        </button>
      </div>
    </div>

    <div class="space-y-3">
      <div class="text-sm font-medium text-neutral">Trigger server alerts</div>
      <div class="flex gap-2 flex-wrap">
        <button @click="triggerAlert('Your session will expire soon')" class="btn btn-outline btn-sm">
          Session Alert
        </button>
        <button @click="triggerAlert('New message received')" class="btn btn-outline btn-sm">
          Message Alert
        </button>
      </div>
    </div>

    <div class="grid grid-cols-2 gap-4 max-sm:grid-cols-1">
      <div class="space-y-3">
        <div class="flex items-center justify-between">
          <div class="text-sm font-medium text-neutral">Notifications</div>
          <div class="text-xs text-neutral/50">{{ props.notificationCount }} total</div>
        </div>
        <div class="min-h-[200px] p-4 rounded-lg bg-base-100 border border-base-300">
          <div v-if="notifications.length === 0" class="text-neutral/50 text-sm text-center py-8">
            No notifications yet
          </div>
          <div v-else class="space-y-2">
            <div
              v-for="notif in notifications"
              :key="notif.id"
              :class="['badge p-3 h-auto w-full justify-start text-sm', getNotificationColor(notif.type)]"
            >
              <div class="flex items-start justify-between gap-2 w-full">
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
          <div class="text-sm font-medium text-neutral">Alerts</div>
          <div class="text-xs text-neutral/50">Recent 3</div>
        </div>
        <div class="min-h-[200px] p-4 rounded-lg bg-base-100 border border-base-300">
          <div v-if="alerts.length === 0" class="text-neutral/50 text-sm text-center py-8">
            No alerts yet
          </div>
          <div v-else class="space-y-2">
            <div v-for="alert in alerts" :key="alert.id" class="p-3 rounded-lg border border-base-300 bg-base-300 text-sm">
              <div class="flex items-start justify-between gap-2">
                <div class="flex-1">{{ alert.message }}</div>
                <div class="text-xs text-neutral/50 shrink-0">
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
