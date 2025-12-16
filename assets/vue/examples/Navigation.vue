<script setup lang="ts">
import { computed } from 'vue'
import { Link, useLiveNavigation } from 'live_vue'

const props = defineProps<{
  currentPath: string
  queryParams: Record<string, string>
}>()

const { navigate, patch } = useLiveNavigation()

const sections = ['overview', 'details', 'settings']
const selectedSection = computed(() => props.queryParams.section || 'overview')

function selectSection(section: string) {
  patch({ section }, { replace: true })
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
      <div class="flex flex-col gap-3">
        <div class="flex items-center gap-3">
          <Link :patch="`${props.currentPath}?filter=active`" class="btn btn-ghost btn-sm">
            patch
          </Link>
          <span class="text-xs text-neutral">Updates URL params, keeps LiveView state</span>
        </div>
        <div class="flex items-center gap-3">
          <Link :patch="`${props.currentPath}?filter=active&id=123`" replace class="btn btn-ghost btn-sm">
            patch + replace
          </Link>
          <span class="text-xs text-neutral">Same as patch, but replaces browser history</span>
        </div>
        <div class="flex items-center gap-3">
          <Link navigate="/examples/events" class="btn btn-ghost btn-sm">
            navigate
          </Link>
          <span class="text-xs text-neutral">Navigates to Events example (new LiveView)</span>
        </div>
        <div class="flex items-center gap-3">
          <Link href="https://vuejs.org" class="btn btn-ghost btn-sm">
            href
          </Link>
          <span class="text-xs text-neutral">Full page load to vuejs.org</span>
        </div>
      </div>
    </div>

    <div class="border-t border-base-300 pt-6 space-y-3">
      <div class="text-sm font-medium text-neutral">
        useLiveNavigation() Hook (programmatic)
      </div>
      <div class="flex flex-col gap-3">
        <div class="flex items-center gap-3">
          <button @click="patch({ sort: 'desc', page: '2' })" class="btn btn-secondary btn-sm">
            patch()
          </button>
          <span class="text-xs text-neutral">Adds sort=desc & page=2 to URL</span>
        </div>
        <div class="flex items-center gap-3">
          <button @click="goToCounter" class="btn btn-primary btn-sm">
            navigate()
          </button>
          <span class="text-xs text-neutral">Navigates to Counter example (new LiveView)</span>
        </div>
      </div>
    </div>

    <div class="border-t border-base-300 pt-6 space-y-3">
      <div class="text-sm font-medium text-neutral">
        Section Navigation (patch with replace)
      </div>
      <div class="flex gap-1 p-1 bg-base-300 rounded-lg w-fit">
        <button
          v-for="section in sections"
          :key="section"
          @click="selectSection(section)"
          :class="[
            'py-2 px-4 rounded-md text-sm font-medium transition-all capitalize',
            selectedSection === section
              ? 'bg-base-200 shadow-sm'
              : 'text-neutral hover:text-base-content'
          ]"
        >
          {{ section }}
        </button>
      </div>
      <div class="p-4 rounded-lg bg-base-300">
        <div class="text-sm capitalize">{{ selectedSection }} content goes here</div>
      </div>
    </div>
  </div>
</template>
