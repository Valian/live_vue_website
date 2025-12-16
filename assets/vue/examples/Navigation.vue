<script setup lang="ts">
import { computed } from 'vue'
import { Link, useLiveNavigation } from 'live_vue'

const props = defineProps<{
  currentPath: string
  queryParams: Record<string, string>
}>()

const { navigate, patch } = useLiveNavigation()

const tabs = ['overview', 'details', 'settings']
const selectedTab = computed(() => props.queryParams.tab || 'overview')

function selectTab(tab: string) {
  patch({ tab }, { replace: true })
}

function goToCounter() {
  navigate('/examples/counter')
}
</script>

<template>
  <div class="card bg-base-200 p-6 space-y-6">
    <div class="space-y-3">
      <div class="text-sm font-medium text-neutral">Current Location</div>
      <div class="p-4 rounded-lg bg-base-300 font-mono text-sm">
        <div class="text-neutral text-xs mb-1">Path:</div>
        <div class="text-primary mb-3">{{ props.currentPath }}</div>
        <div class="text-neutral text-xs mb-1">Query Params:</div>
        <div class="whitespace-pre">{{
          Object.keys(props.queryParams).length > 0
            ? JSON.stringify(props.queryParams, null, 2)
            : '{}'
        }}</div>
      </div>
    </div>

    <div class="border-t border-base-300 pt-6 space-y-3">
      <div class="text-sm font-medium text-neutral">
        Link Component (declarative)
      </div>
      <div class="flex gap-2 flex-wrap">
        <Link href="https://vuejs.org" class="btn btn-ghost">
          href (external)
        </Link>
        <Link navigate="/examples/events" class="btn btn-ghost">
          navigate (new LiveView)
        </Link>
        <Link :patch="`${props.currentPath}?tab=demo`" class="btn btn-ghost">
          patch (update params)
        </Link>
        <Link :patch="`${props.currentPath}?tab=demo&id=123`" replace class="btn btn-ghost">
          patch with replace
        </Link>
      </div>
    </div>

    <div class="border-t border-base-300 pt-6 space-y-3">
      <div class="text-sm font-medium text-neutral">
        useLiveNavigation() Hook (programmatic)
      </div>
      <div class="flex gap-2 flex-wrap">
        <button @click="goToCounter" class="btn btn-primary">
          navigate() to Counter
        </button>
        <button @click="patch({ demo: 'true' })" class="btn btn-secondary">
          patch() with object
        </button>
      </div>
    </div>

    <div class="border-t border-base-300 pt-6 space-y-3">
      <div class="text-sm font-medium text-neutral">
        Tab Navigation (patch with replace)
      </div>
      <div class="flex gap-1 p-1 bg-base-300 rounded-lg w-fit">
        <button
          v-for="tab in tabs"
          :key="tab"
          @click="selectTab(tab)"
          :class="[
            'py-2 px-4 rounded-md text-sm font-medium transition-all capitalize',
            selectedTab === tab
              ? 'bg-base-200 shadow-sm'
              : 'text-neutral hover:text-base-content'
          ]"
        >
          {{ tab }}
        </button>
      </div>
      <div class="p-4 rounded-lg bg-base-300">
        <div class="text-sm capitalize">{{ selectedTab }} content goes here</div>
      </div>
    </div>
  </div>
</template>
