<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from "vue"
import DataFlowLayer from "./components/DataFlowLayer.vue"
import FlowConnection from "./components/FlowConnection.vue"

const isAnimating = ref(true)
const animationProgress = ref(0) // 0 to steps.length, fractional
const STEP_DURATION_MS = 2000
const STEPS_COUNT = 6

let lastTimestamp: number | null = null
let animationFrameId: number | null = null

const currentStep = computed(() => Math.floor(animationProgress.value) % STEPS_COUNT)
const stepProgress = computed(() => animationProgress.value % 1)

// Server count increments each full cycle
const serverCount = computed(() => 5 + Math.floor(animationProgress.value / STEPS_COUNT))

// Local Vue state (static for display purposes)
const localDiff = 3

const steps = [
  {
    id: "click",
    label: "User Clicks",
    desc: "Button has @click=\"$live.pushEvent('inc')\" handler.",
    highlight: "dom-button",
  },
  { id: "event-up", label: "Event Sent", desc: "Click event flows to server via WebSocket.", highlight: "event" },
  {
    id: "update",
    label: "Server Updates",
    desc: "handle_event updates assigns. Count increments.",
    highlight: "server-update",
  },
  {
    id: "props-down",
    label: "Props Flow Down",
    desc: "New server state passed to Vue component as props.",
    highlight: "props",
  },
  { id: "render", label: "Vue Renders", desc: "Vue reactively updates its virtual DOM from new props.", highlight: "render" },
  {
    id: "dom-update",
    label: "DOM Updated",
    desc: "Changes applied to the real DOM. Cycle complete.",
    highlight: "dom",
  },
]

const currentHighlight = computed(() => steps[currentStep.value].highlight)

// Dot progress for each connection (null when not active)
const eventConnectionDot = computed(() => (currentStep.value === 1 ? 1 - stepProgress.value : null))
const propsConnectionDot = computed(() => (currentStep.value === 3 ? stepProgress.value : null))
const renderConnectionDot = computed(() => (currentStep.value === 4 ? stepProgress.value : null))

function animate(timestamp: number) {
  if (lastTimestamp === null) {
    lastTimestamp = timestamp
  }

  if (isAnimating.value) {
    const delta = timestamp - lastTimestamp
    animationProgress.value += delta / STEP_DURATION_MS
  }

  lastTimestamp = timestamp
  animationFrameId = requestAnimationFrame(animate)
}

onMounted(() => {
  animationFrameId = requestAnimationFrame(animate)
})

onUnmounted(() => {
  if (animationFrameId !== null) {
    cancelAnimationFrame(animationFrameId)
  }
})

function toggleAnimation() {
  isAnimating.value = !isAnimating.value
}
</script>

<template>
  <div
    class="flex flex-col gap-5 p-8 bg-[rgba(10,10,15,0.95)] border border-white/[0.08] rounded-2xl backdrop-blur-xl font-mono text-[0.8rem] w-[520px]"
  >
    <div class="flex gap-6">
      <!-- Main column with layers -->
      <div class="flex-1 flex flex-col">
        <!-- SERVER LAYER -->
        <DataFlowLayer
          badge="Server"
          title="LiveView"
          :highlighted="currentHighlight === 'server' || currentHighlight === 'server-update'"
          accent-color="phoenix"
        >
          <template #icon>
            <svg
              class="w-[18px] h-[18px] text-phoenix"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="1.5"
            >
              <rect x="2" y="3" width="20" height="6" rx="1" />
              <rect x="2" y="11" width="20" height="6" rx="1" />
              <circle cx="6" cy="6" r="1" fill="currentColor" />
              <circle cx="6" cy="14" r="1" fill="currentColor" />
            </svg>
          </template>
          <div class="flex flex-col gap-1 py-2.5 px-3 bg-black/30 rounded-md">
            <span class="text-[#6a6a80] text-[0.7rem]"># assigns</span>
            <span class="flex gap-1">
              <span class="text-[#e06c75]">@count</span>
              <span class="text-[#6a6a80]"> = </span>
              <span
                class="text-[#d19a66] transition-all duration-300"
                :class="{
                  'text-white [text-shadow:0_0_12px_currentColor,0_0_24px_currentColor]':
                    currentHighlight === 'server-update',
                }"
                >{{ serverCount }}</span
              >
            </span>
          </div>
        </DataFlowLayer>

        <!-- Connection: Server to Vue -->
        <FlowConnection
          label="props"
          label-position="right"
          :highlighted="currentHighlight === 'props'"
          :dot-progress="propsConnectionDot"
          accent-color="phoenix"
        />

        <!-- VUE LAYER -->
        <DataFlowLayer
          badge="Client"
          title="Vue Component"
          :highlighted="currentHighlight === 'render' || currentHighlight === 'props'"
          accent-color="vue"
        >
          <template #icon>
            <svg
              class="w-[18px] h-[18px] text-vue"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="1.5"
            >
              <polygon points="12,2 22,8.5 22,15.5 12,22 2,15.5 2,8.5" />
              <polygon points="12,6 17,9 17,15 12,18 7,15 7,9" fill="currentColor" opacity="0.3" />
            </svg>
          </template>
          <div class="flex flex-col gap-1.5 py-2.5 px-3 bg-black/30 rounded-md">
            <span class="flex gap-1">
              <span class="text-[#c678dd]">const</span>
              <span class="text-[#61afef]">props</span>
              <span class="text-[#6a6a80]"> = { </span>
              <span class="text-[#e06c75]">count</span>
              <span class="text-[#6a6a80]">: </span>
              <span
                class="text-[#d19a66] transition-all duration-300"
                :class="{
                  'text-white [text-shadow:0_0_12px_currentColor,0_0_24px_currentColor]': currentHighlight === 'props',
                }"
                >{{ serverCount }}</span
              >
              <span class="text-[#6a6a80]"> }</span>
            </span>
            <span class="flex gap-1">
              <span class="text-[#c678dd]">const</span>
              <span class="text-[#61afef]">diff</span>
              <span class="text-[#6a6a80]"> = </span>
              <span class="text-[#c678dd]">ref</span>
              <span class="text-[#6a6a80]">(</span>
              <span class="text-[#d19a66]">{{ localDiff }}</span>
              <span class="text-[#6a6a80]">)</span>
              <span class="text-[#6a6a80] text-[0.65rem] ml-1">// local</span>
            </span>
          </div>
        </DataFlowLayer>

        <!-- Connection: Vue to DOM -->
        <FlowConnection
          label="render"
          label-position="left"
          :highlighted="currentHighlight === 'render' || currentHighlight === 'dom'"
          :dot-progress="renderConnectionDot"
          accent-color="vue"
        />

        <!-- DOM LAYER -->
        <DataFlowLayer
          badge="Browser"
          title="Rendered DOM"
          :highlighted="currentHighlight === 'dom' || currentHighlight === 'dom-button'"
          accent-color="vue"
        >
          <template #icon>
            <svg
              class="w-[18px] h-[18px] text-vue"
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="1.5"
            >
              <rect x="3" y="4" width="18" height="14" rx="2" />
              <line x1="3" y1="9" x2="21" y2="9" />
              <circle cx="6" cy="6.5" r="0.75" fill="currentColor" />
              <circle cx="9" cy="6.5" r="0.75" fill="currentColor" />
            </svg>
          </template>
          <div class="flex flex-col items-center gap-2 p-4 bg-black/30 rounded-md">
            <div class="flex items-center gap-3">
              <span
                class="font-serif text-[2.5rem] text-landing-text transition-all duration-300 min-w-[2ch] text-center"
                :class="{
                  'text-white [text-shadow:0_0_12px_currentColor,0_0_24px_currentColor]': currentHighlight === 'dom',
                }"
                >{{ serverCount + localDiff }}</span
              >
              <button
                class="flex items-center justify-center w-10 h-10 rounded-lg border border-white/[0.08] bg-phoenix/10 text-phoenix text-xl cursor-default transition-all duration-300"
                :class="{
                  'border-phoenix shadow-[0_0_15px_rgba(253,79,0,0.4)] scale-110': currentHighlight === 'dom-button',
                }"
              >
                <span class="leading-none">+{{ localDiff }}</span>
              </button>
            </div>
            <div
              class="text-[0.65rem] text-[#6a6a80] py-1 px-2.5 bg-black/30 rounded transition-all duration-300"
              :class="{ 'text-phoenix bg-phoenix/15': currentHighlight === 'dom-button' }"
            >
              @click="$live.pushEvent('inc', { diff })"
            </div>
          </div>
        </DataFlowLayer>
      </div>

      <!-- Event path column (right side) -->
      <div class="w-[50px] relative flex flex-col items-center justify-center">
        <div
          class="absolute top-[50px] bottom-[50px] w-0.5 bg-white/[0.08] transition-all duration-400"
          :class="{ 'bg-vue shadow-[0_0_8px_rgba(66,184,131,0.4)]': currentHighlight === 'event' }"
        />
        <div
          v-if="eventConnectionDot !== null"
          class="absolute w-2.5 h-2.5 rounded-full left-1/2 -translate-x-1/2 -translate-y-1/2 bg-vue shadow-[0_0_10px_var(--color-vue),0_0_20px_var(--color-vue)] z-10"
          :style="{ top: `calc(50px + ${eventConnectionDot} * (100% - 100px))` }"
        />
        <div
          class="flex flex-col items-center gap-1 py-1.5 px-2 bg-[rgba(10,10,15,0.95)] border border-white/[0.08] rounded text-[0.6rem] uppercase tracking-wide text-[#6a6a80] transition-all duration-400 z-5"
          :class="{ 'text-vue border-vue shadow-[0_0_10px_rgba(66,184,131,0.4)]': currentHighlight === 'event' }"
        >
          <svg class="w-2.5 h-2.5" viewBox="0 0 12 12">
            <path d="M6 12 L6 2 M2 6 L6 2 L10 6" stroke="currentColor" fill="none" stroke-width="2" />
          </svg>
          <span>event</span>
        </div>
        <!-- Connection indicators -->
        <div
          class="absolute h-0.5 w-12 right-6 top-[50px] bg-white/[0.08] transition-all duration-400"
          :class="{ 'bg-vue': currentHighlight === 'event' }"
        />
        <div
          class="absolute h-0.5 w-12 right-6 bottom-[50px] bg-white/[0.08] transition-all duration-400"
          :class="{ 'bg-vue': currentHighlight === 'event' }"
        />
      </div>
    </div>

    <!-- Step indicator and controls -->
    <div class="flex items-center gap-4 pt-4 border-t border-white/[0.08]">
      <span class="text-[0.7rem] text-[#6a6a80] tabular-nums w-8">{{ currentStep + 1 }}/{{ steps.length }}</span>
      <div class="flex-1 flex flex-col gap-0.5">
        <span class="text-xs font-semibold text-landing-text">{{ steps[currentStep].label }}</span>
        <span class="text-[0.65rem] text-[#6a6a80]">{{ steps[currentStep].desc }}</span>
      </div>
      <button
        class="w-7 h-7 flex items-center justify-center bg-white/5 border border-white/[0.08] rounded-md text-[#6a6a80] cursor-pointer transition-all duration-200 hover:text-landing-text hover:border-[#6a6a80]"
        @click="toggleAnimation"
      >
        <svg v-if="isAnimating" class="w-3 h-3" viewBox="0 0 24 24" fill="currentColor">
          <rect x="6" y="4" width="4" height="16" rx="1" />
          <rect x="14" y="4" width="4" height="16" rx="1" />
        </svg>
        <svg v-else class="w-3 h-3" viewBox="0 0 24 24" fill="currentColor">
          <polygon points="5,3 19,12 5,21" />
        </svg>
      </button>
    </div>

    <!-- Legend -->
    <div class="flex justify-center gap-6 text-[0.65rem] text-[#6a6a80]">
      <div class="flex items-center gap-1.5">
        <span class="w-2 h-2 rounded-full bg-phoenix shadow-[0_0_6px_rgba(253,79,0,0.4)]"></span>
        <span>Phoenix/Server</span>
      </div>
      <div class="flex items-center gap-1.5">
        <span class="w-2 h-2 rounded-full bg-vue shadow-[0_0_6px_rgba(66,184,131,0.4)]"></span>
        <span>Vue/Client</span>
      </div>
    </div>
  </div>
</template>
