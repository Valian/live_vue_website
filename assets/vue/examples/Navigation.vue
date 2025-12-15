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
  <div class="p-6 rounded-xl border border-landing-border space-y-6">
    <div class="space-y-3">
      <div class="text-sm font-medium text-landing-muted">Current Location</div>
      <div class="p-4 rounded-lg bg-landing-elevated border border-landing-border font-mono text-sm">
        <div class="text-landing-muted text-xs mb-1">Path:</div>
        <div class="text-vue mb-3">{{ props.currentPath }}</div>
        <div class="text-landing-muted text-xs mb-1">Query Params:</div>
        <div class="text-landing-text whitespace-pre">{{
          Object.keys(props.queryParams).length > 0
            ? JSON.stringify(props.queryParams, null, 2)
            : '{}'
        }}</div>
      </div>
    </div>

    <div class="border-t border-landing-border pt-6 space-y-3">
      <div class="text-sm font-medium text-landing-muted">
        Link Component (declarative)
      </div>
      <div class="flex gap-2 flex-wrap">
        <Link
          href="https://vuejs.org"
          class="px-4 py-2 border border-landing-border rounded hover:bg-white/5 transition-colors"
        >
          href (external)
        </Link>
        <Link
          navigate="/examples/events"
          class="px-4 py-2 border border-landing-border rounded hover:bg-white/5 transition-colors"
        >
          navigate (new LiveView)
        </Link>
        <Link
          :patch="`${props.currentPath}?tab=demo`"
          class="px-4 py-2 border border-landing-border rounded hover:bg-white/5 transition-colors"
        >
          patch (update params)
        </Link>
        <Link
          :patch="`${props.currentPath}?tab=demo&id=123`"
          replace
          class="px-4 py-2 border border-landing-border rounded hover:bg-white/5 transition-colors"
        >
          patch with replace
        </Link>
      </div>
    </div>

    <div class="border-t border-landing-border pt-6 space-y-3">
      <div class="text-sm font-medium text-landing-muted">
        useLiveNavigation() Hook (programmatic)
      </div>
      <div class="flex gap-2 flex-wrap">
        <button
          @click="goToCounter"
          class="px-4 py-2 bg-vue text-white rounded font-medium hover:bg-vue/90 transition-colors"
        >
          navigate() to Counter
        </button>
        <button
          @click="patch({ demo: 'true' })"
          class="px-4 py-2 bg-phoenix text-white rounded font-medium hover:bg-phoenix/90 transition-colors"
        >
          patch() with object
        </button>
      </div>
    </div>

    <div class="border-t border-landing-border pt-6 space-y-3">
      <div class="text-sm font-medium text-landing-muted">
        Tab Navigation (patch with replace)
      </div>
      <div class="flex gap-1 p-1 bg-landing-elevated rounded-lg w-fit">
        <button
          v-for="tab in tabs"
          :key="tab"
          @click="selectTab(tab)"
          :class="[
            'py-2 px-4 rounded-md text-sm font-medium transition-all capitalize',
            selectedTab === tab
              ? 'bg-landing-card text-landing-text shadow-sm'
              : 'text-landing-muted hover:text-landing-text'
          ]"
        >
          {{ tab }}
        </button>
      </div>
      <div class="p-4 rounded-lg bg-landing-card border border-landing-border">
        <div class="text-landing-text text-sm capitalize">{{ selectedTab }} content goes here</div>
      </div>
    </div>
  </div>
</template>
