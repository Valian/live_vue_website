<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from "vue"
import DataFlowLayer from "./components/DataFlowLayer.vue"
import FlowConnection from "./components/FlowConnection.vue"

// Animation state
const isAnimating = ref(true)
const currentStepIndex = ref(0)
const dotProgress = ref(0) // 0-1 for animated dots

// The actual values at each layer (these update at different times)
const serverCount = ref(5)
const vuePropsCount = ref(5)
const domCount = ref(5)

// The increment amount (what the button adds)
const INCREMENT = 1

// Animation timing
const STEP_DURATION_MS = 1560
const DOT_DURATION_MS = 780

let animationAbort: AbortController | null = null

type Step = {
  id: string
  label: string
  desc: string
  highlight: string
}

const steps: Step[] = [
  {
    id: "click",
    label: "User Clicks",
    desc: `Button triggers $live.pushEvent('inc').`,
    highlight: "dom-button",
  },
  {
    id: "event-up",
    label: "Event Sent",
    desc: "Event travels to server via WebSocket.",
    highlight: "event",
  },
  {
    id: "server-update",
    label: "Server Updates",
    desc: "handle_event increments @count assign.",
    highlight: "server-update",
  },
  {
    id: "props-down",
    label: "Props Flow",
    desc: "New count sent to Vue component as props.",
    highlight: "props",
  },
  {
    id: "vue-render",
    label: "Vue Renders",
    desc: "Vue updates virtual DOM from new props.",
    highlight: "render",
  },
  {
    id: "dom-update",
    label: "DOM Updated",
    desc: "Real DOM reflects the new value.",
    highlight: "dom",
  },
]

const currentStep = computed(() => steps[currentStepIndex.value])
const currentHighlight = computed(() => currentStep.value.highlight)

// Dot visibility for each connection
const eventDotProgress = computed(() => (currentHighlight.value === "event" ? dotProgress.value : null))
const propsDotProgress = computed(() => (currentHighlight.value === "props" ? dotProgress.value : null))
const renderDotProgress = computed(() => (currentHighlight.value === "render" ? dotProgress.value : null))

// Helper to wait with abort support
function wait(ms: number, signal: AbortSignal): Promise<void> {
  return new Promise((resolve, reject) => {
    const timeout = setTimeout(resolve, ms)
    signal.addEventListener("abort", () => {
      clearTimeout(timeout)
      reject(new DOMException("Aborted", "AbortError"))
    })
  })
}

// Animate dot from 0 to 1
async function animateDot(signal: AbortSignal): Promise<void> {
  const startTime = performance.now()
  return new Promise((resolve, reject) => {
    function tick() {
      if (signal.aborted) {
        reject(new DOMException("Aborted", "AbortError"))
        return
      }
      const elapsed = performance.now() - startTime
      const progress = Math.min(elapsed / DOT_DURATION_MS, 1)
      dotProgress.value = progress
      if (progress < 1) {
        requestAnimationFrame(tick)
      } else {
        resolve()
      }
    }
    requestAnimationFrame(tick)
  })
}

// Main animation loop
async function runAnimationLoop(signal: AbortSignal): Promise<void> {
  while (!signal.aborted) {
    // Step 0: Click - button highlights
    currentStepIndex.value = 0
    dotProgress.value = 0
    await wait(STEP_DURATION_MS, signal)

    // Step 1: Event travels up (dot animates, but inverted for upward motion)
    currentStepIndex.value = 1
    await animateDot(signal)
    await wait(STEP_DURATION_MS - DOT_DURATION_MS, signal)

    // Step 2: Server updates - increment the server count
    currentStepIndex.value = 2
    dotProgress.value = 0
    serverCount.value += INCREMENT
    await wait(STEP_DURATION_MS, signal)

    // Step 3: Props flow down (dot animates)
    currentStepIndex.value = 3
    await animateDot(signal)
    vuePropsCount.value = serverCount.value // Props arrive at Vue
    await wait(STEP_DURATION_MS - DOT_DURATION_MS, signal)

    // Step 4: Vue renders (dot animates to DOM)
    currentStepIndex.value = 4
    await animateDot(signal)
    await wait(STEP_DURATION_MS - DOT_DURATION_MS, signal)

    // Step 5: DOM updated
    currentStepIndex.value = 5
    dotProgress.value = 0
    domCount.value = vuePropsCount.value // DOM reflects the value
    await wait(STEP_DURATION_MS, signal)
  }
}

function startAnimation() {
  if (animationAbort) {
    animationAbort.abort()
  }
  animationAbort = new AbortController()
  runAnimationLoop(animationAbort.signal).catch((e) => {
    if (e.name !== "AbortError") {
      console.error("Animation error:", e)
    }
  })
}

function stopAnimation() {
  if (animationAbort) {
    animationAbort.abort()
    animationAbort = null
  }
}

function toggleAnimation() {
  if (isAnimating.value) {
    stopAnimation()
  } else {
    startAnimation()
  }
  isAnimating.value = !isAnimating.value
}

onMounted(() => {
  if (isAnimating.value) {
    startAnimation()
  }
})

onUnmounted(() => {
  stopAnimation()
})
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
          :highlighted="currentHighlight === 'server-update'"
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
            <span class="text-[#6a6a80] text-xs"># assigns</span>
            <span class="flex gap-1">
              <span class="text-[#e06c75]">@count</span>
              <span class="text-[#6a6a80]"> = </span>
              <span
                class="text-[#d19a66] transition-all duration-300 tabular-nums"
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
          :dot-progress="propsDotProgress"
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
                class="text-[#d19a66] transition-all duration-300 tabular-nums"
                :class="{
                  'text-white [text-shadow:0_0_12px_currentColor,0_0_24px_currentColor]': currentHighlight === 'props',
                }"
                >{{ vuePropsCount }}</span
              >
              <span class="text-[#6a6a80]"> }</span>
            </span>
          </div>
        </DataFlowLayer>

        <!-- Connection: Vue to DOM -->
        <FlowConnection
          label="render"
          label-position="left"
          :highlighted="currentHighlight === 'render' || currentHighlight === 'dom'"
          :dot-progress="renderDotProgress"
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
                class="font-serif text-[2.5rem] text-landing-text transition-all duration-300 min-w-[2ch] text-center tabular-nums"
                :class="{
                  'text-white [text-shadow:0_0_12px_currentColor,0_0_24px_currentColor]': currentHighlight === 'dom',
                }"
                >{{ domCount }}</span
              >
              <button
                class="flex items-center justify-center w-10 h-10 rounded-lg border border-white/[0.08] bg-phoenix/10 text-phoenix text-xl cursor-default transition-all duration-300"
                :class="{
                  'border-phoenix shadow-[0_0_15px_rgba(253,79,0,0.4)] scale-110': currentHighlight === 'dom-button',
                }"
              >
                <span class="leading-none">+{{ INCREMENT }}</span>
              </button>
            </div>
            <div
              class="text-xs text-[#6a6a80] py-1 px-2.5 bg-black/30 rounded transition-all duration-300"
              :class="{ 'text-phoenix bg-phoenix/15': currentHighlight === 'dom-button' }"
            >
              @click="$live.pushEvent('inc')"
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
          v-if="eventDotProgress !== null"
          class="absolute w-2.5 h-2.5 rounded-full left-1/2 -translate-x-1/2 -translate-y-1/2 bg-vue shadow-[0_0_10px_var(--color-vue),0_0_20px_var(--color-vue)] z-10"
          :style="{ top: `calc(50px + ${1 - eventDotProgress} * (100% - 100px))` }"
        />
        <div
          class="flex flex-col items-center gap-1 py-1.5 px-2 bg-[rgba(10,10,15,0.95)] border border-white/[0.08] rounded text-xs uppercase tracking-wide text-[#6a6a80] transition-all duration-400 z-5"
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
      <span class="text-xs text-[#6a6a80] tabular-nums w-8">{{ currentStepIndex + 1 }}/{{ steps.length }}</span>
      <div class="flex-1 flex flex-col gap-0.5">
        <span class="text-xs font-semibold text-landing-text">{{ currentStep.label }}</span>
        <span class="text-xs text-[#6a6a80]">{{ currentStep.desc }}</span>
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
    <div class="flex justify-center gap-6 text-xs text-[#6a6a80]">
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
