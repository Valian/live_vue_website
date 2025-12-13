<script setup lang="ts">
import { ref, onMounted, onUnmounted, computed } from 'vue'

const isAnimating = ref(true)
const currentStep = ref(0)
const serverCount = ref(5)

let animationInterval: number | null = null

const steps = [
  {
    id: 'initial',
    label: 'Server State',
    desc: 'LiveView owns the data. Count lives in server assigns.',
    highlight: 'server'
  },
  {
    id: 'props-down',
    label: 'Props Flow Down',
    desc: 'Server state passed to Vue component as props.',
    highlight: 'props',
    dot: 'down'
  },
  {
    id: 'render',
    label: 'Vue Renders DOM',
    desc: 'Vue reactively renders the UI from props.',
    highlight: 'dom',
    dot: 'render'
  },
  {
    id: 'click',
    label: 'User Clicks',
    desc: 'Button has phx-click="inc" attribute.',
    highlight: 'dom-button'
  },
  {
    id: 'event-up',
    label: 'Event Sent',
    desc: 'Click event flows to server via WebSocket.',
    highlight: 'event',
    dot: 'up'
  },
  {
    id: 'update',
    label: 'Server Updates',
    desc: 'handle_event updates assigns. Cycle repeats.',
    highlight: 'server-update'
  },
]

const dotAnimation = computed(() => steps[currentStep.value].dot || null)

onMounted(() => {
  startAnimation()
})

onUnmounted(() => {
  if (animationInterval) clearInterval(animationInterval)
})

function startAnimation() {
  animationInterval = window.setInterval(() => {
    if (!isAnimating.value) return

    const nextStep = (currentStep.value + 1) % steps.length

    // Update count when cycle completes
    if (nextStep === 0) {
      serverCount.value = serverCount.value + 1
    }

    currentStep.value = nextStep
  }, 2000)
}

function toggleAnimation() {
  isAnimating.value = !isAnimating.value
}

function goToStep(index: number) {
  currentStep.value = index
}
</script>

<template>
  <div class="flex flex-col gap-5 p-7 bg-[rgba(10,10,15,0.95)] border border-white/[0.08] rounded-2xl backdrop-blur-xl font-mono text-[0.8rem] w-[480px]">
    <div class="flex gap-6">
      <!-- Main column with layers -->
      <div class="flex-1 flex flex-col">
        <!-- SERVER LAYER -->
        <div
          class="p-4 px-5 rounded-[10px] border border-white/[0.08] bg-[rgba(20,20,28,0.9)] transition-all duration-400 relative"
          :class="{
            'border-phoenix shadow-[0_0_25px_rgba(253,79,0,0.4),inset_0_0_20px_rgba(253,79,0,0.05)]': steps[currentStep].highlight === 'server' || steps[currentStep].highlight === 'server-update'
          }"
        >
          <div class="absolute -top-2 right-3 text-[0.6rem] uppercase tracking-widest py-0.5 px-2 rounded bg-[rgba(10,10,15,0.95)] border border-white/[0.08] text-[#6a6a80]">
            Server
          </div>
          <div class="flex items-center gap-2 text-xs font-semibold text-landing-text mb-3">
            <svg class="w-[18px] h-[18px] text-phoenix" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <rect x="2" y="3" width="20" height="6" rx="1" />
              <rect x="2" y="11" width="20" height="6" rx="1" />
              <circle cx="6" cy="6" r="1" fill="currentColor" />
              <circle cx="6" cy="14" r="1" fill="currentColor" />
            </svg>
            LiveView
          </div>
          <div class="flex flex-col gap-1 py-2.5 px-3 bg-black/30 rounded-md">
            <span class="text-[#6a6a80] text-[0.7rem]"># assigns</span>
            <span class="flex gap-1">
              <span class="text-[#e06c75]">@count</span>
              <span class="text-[#6a6a80]"> = </span>
              <span
                class="text-[#d19a66] transition-all duration-300"
                :class="{ 'text-white [text-shadow:0_0_12px_currentColor,0_0_24px_currentColor]': steps[currentStep].highlight === 'server-update' }"
              >{{ serverCount }}</span>
            </span>
          </div>
        </div>

        <!-- Connection: Server to Vue -->
        <div class="relative h-11 flex justify-center items-center">
          <div
            class="w-0.5 h-full bg-white/[0.08] transition-all duration-400"
            :class="{ 'bg-phoenix shadow-[0_0_8px_rgba(253,79,0,0.4)]': steps[currentStep].highlight === 'props' }"
          ></div>
          <div
            v-if="dotAnimation === 'down'"
            :key="'down-' + currentStep"
            class="absolute w-2.5 h-2.5 rounded-full left-1/2 -translate-x-1/2 z-10 bg-phoenix shadow-[0_0_10px_var(--color-phoenix),0_0_20px_var(--color-phoenix)] animate-[flow-down_1.5s_ease-in-out_forwards]"
          ></div>
          <div
            class="absolute left-[calc(50%+15px)] flex items-center gap-1.5 py-1 px-2.5 bg-[rgba(10,10,15,0.95)] border border-white/[0.08] rounded text-[0.65rem] uppercase tracking-wide text-[#6a6a80] transition-all duration-400"
            :class="{ 'text-phoenix border-phoenix shadow-[0_0_10px_rgba(253,79,0,0.4)]': steps[currentStep].highlight === 'props' }"
          >
            <span>props</span>
            <svg class="w-2.5 h-2.5" viewBox="0 0 12 12">
              <path d="M6 0 L6 10 M2 6 L6 10 L10 6" stroke="currentColor" fill="none" stroke-width="2"/>
            </svg>
          </div>
        </div>

        <!-- VUE LAYER -->
        <div
          class="p-4 px-5 rounded-[10px] border border-white/[0.08] bg-[rgba(20,20,28,0.9)] transition-all duration-400 relative"
          :class="{ 'border-vue shadow-[0_0_25px_rgba(66,184,131,0.4),inset_0_0_20px_rgba(66,184,131,0.05)]': steps[currentStep].highlight === 'render' || steps[currentStep].highlight === 'props' }"
        >
          <div class="absolute -top-2 right-3 text-[0.6rem] uppercase tracking-widest py-0.5 px-2 rounded bg-[rgba(10,10,15,0.95)] border border-white/[0.08] text-[#6a6a80]">
            Client
          </div>
          <div class="flex items-center gap-2 text-xs font-semibold text-landing-text mb-3">
            <svg class="w-[18px] h-[18px] text-vue" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <polygon points="12,2 22,8.5 22,15.5 12,22 2,15.5 2,8.5" />
              <polygon points="12,6 17,9 17,15 12,18 7,15 7,9" fill="currentColor" opacity="0.3" />
            </svg>
            Vue Component
          </div>
          <div class="flex flex-col gap-1 py-2.5 px-3 bg-black/30 rounded-md">
            <span class="text-[#6a6a80] text-[0.7rem]">// props from server</span>
            <span class="flex gap-1">
              <span class="text-[#e06c75]">count</span>
              <span class="text-[#6a6a80]">: </span>
              <span
                class="text-[#d19a66] transition-all duration-300"
                :class="{ 'text-white [text-shadow:0_0_12px_currentColor,0_0_24px_currentColor]': steps[currentStep].highlight === 'props' }"
              >{{ serverCount }}</span>
            </span>
          </div>
        </div>

        <!-- Connection: Vue to DOM -->
        <div class="relative h-11 flex justify-center items-center">
          <div
            class="w-0.5 h-full bg-white/[0.08] transition-all duration-400"
            :class="{ 'bg-vue shadow-[0_0_8px_rgba(66,184,131,0.4)]': steps[currentStep].highlight === 'render' || steps[currentStep].highlight === 'dom' }"
          ></div>
          <div
            v-if="dotAnimation === 'render'"
            :key="'render-' + currentStep"
            class="absolute w-2.5 h-2.5 rounded-full left-1/2 -translate-x-1/2 z-10 bg-vue shadow-[0_0_10px_var(--color-vue),0_0_20px_var(--color-vue)] animate-[flow-down_1s_ease-in-out_forwards]"
          ></div>
          <div
            class="absolute right-[calc(50%+15px)] left-auto flex items-center gap-1.5 py-1 px-2.5 bg-[rgba(10,10,15,0.95)] border border-white/[0.08] rounded text-[0.65rem] uppercase tracking-wide text-[#6a6a80] transition-all duration-400"
            :class="{ 'text-vue border-vue shadow-[0_0_10px_rgba(66,184,131,0.4)]': steps[currentStep].highlight === 'render' || steps[currentStep].highlight === 'dom' }"
          >
            <span>render</span>
            <svg class="w-2.5 h-2.5" viewBox="0 0 12 12">
              <path d="M6 0 L6 10 M2 6 L6 10 L10 6" stroke="currentColor" fill="none" stroke-width="2"/>
            </svg>
          </div>
        </div>

        <!-- DOM LAYER -->
        <div
          class="p-4 px-5 rounded-[10px] border border-white/[0.08] bg-[rgba(20,20,28,0.9)] transition-all duration-400 relative"
          :class="{
            'border-vue shadow-[0_0_25px_rgba(66,184,131,0.4),inset_0_0_20px_rgba(66,184,131,0.05)]': steps[currentStep].highlight === 'dom' || steps[currentStep].highlight === 'dom-button'
          }"
        >
          <div class="absolute -top-2 right-3 text-[0.6rem] uppercase tracking-widest py-0.5 px-2 rounded bg-[rgba(10,10,15,0.95)] border border-white/[0.08] text-[#6a6a80]">
            Browser
          </div>
          <div class="flex items-center gap-2 text-xs font-semibold text-landing-text mb-3">
            <svg class="w-[18px] h-[18px] text-vue" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <rect x="3" y="4" width="18" height="14" rx="2"/>
              <line x1="3" y1="9" x2="21" y2="9"/>
              <circle cx="6" cy="6.5" r="0.75" fill="currentColor"/>
              <circle cx="9" cy="6.5" r="0.75" fill="currentColor"/>
            </svg>
            Rendered DOM
          </div>
          <div class="flex flex-col items-center gap-2 p-4 bg-black/30 rounded-md">
            <div class="flex items-center gap-4">
              <span
                class="font-serif text-[2.5rem] text-landing-text transition-all duration-300 min-w-[2ch] text-center"
                :class="{ 'text-white [text-shadow:0_0_12px_currentColor,0_0_24px_currentColor]': steps[currentStep].highlight === 'dom' }"
              >{{ serverCount }}</span>
              <button
                class="w-9 h-9 flex items-center justify-center rounded-lg border border-white/[0.08] bg-phoenix/10 text-phoenix text-2xl cursor-default transition-all duration-300"
                :class="{ 'border-phoenix shadow-[0_0_15px_rgba(253,79,0,0.4)] scale-110': steps[currentStep].highlight === 'dom-button' }"
              >
                <span class="leading-none">+</span>
              </button>
            </div>
            <div
              class="text-[0.65rem] text-[#6a6a80] py-1 px-2.5 bg-black/30 rounded transition-all duration-300"
              :class="{ 'text-phoenix bg-phoenix/15': steps[currentStep].highlight === 'dom-button' }"
            >
              phx-click="inc"
            </div>
          </div>
        </div>
      </div>

      <!-- Event path column (right side) -->
      <div
        class="w-[50px] relative flex flex-col items-center justify-center"
        :class="{ 'event-active': steps[currentStep].highlight === 'event' }"
      >
        <div
          class="absolute top-5 bottom-5 w-0.5 bg-white/[0.08] transition-all duration-400"
          :class="{ 'bg-vue shadow-[0_0_8px_rgba(66,184,131,0.4)]': steps[currentStep].highlight === 'event' }"
        ></div>
        <div
          v-if="dotAnimation === 'up'"
          :key="'up-' + currentStep"
          class="absolute w-2.5 h-2.5 rounded-full left-1/2 -translate-x-1/2 bg-vue shadow-[0_0_10px_var(--color-vue),0_0_20px_var(--color-vue)] animate-[flow-up_1.5s_ease-in-out_forwards] z-10"
        ></div>
        <div
          class="flex flex-col items-center gap-1 py-1.5 px-2 bg-[rgba(10,10,15,0.95)] border border-white/[0.08] rounded text-[0.6rem] uppercase tracking-wide text-[#6a6a80] transition-all duration-400 z-5"
          :class="{ 'text-vue border-vue shadow-[0_0_10px_rgba(66,184,131,0.4)]': steps[currentStep].highlight === 'event' }"
        >
          <svg class="w-2.5 h-2.5" viewBox="0 0 12 12">
            <path d="M6 12 L6 2 M2 6 L6 2 L10 6" stroke="currentColor" fill="none" stroke-width="2"/>
          </svg>
          <span>event</span>
        </div>
        <!-- Connection indicators -->
        <div
          class="absolute h-0.5 w-5 right-6 top-5 bg-white/[0.08] transition-all duration-400"
          :class="{ 'bg-vue': steps[currentStep].highlight === 'event' }"
        ></div>
        <div
          class="absolute h-0.5 w-5 right-6 bottom-5 bg-white/[0.08] transition-all duration-400"
          :class="{ 'bg-vue': steps[currentStep].highlight === 'event' }"
        ></div>
      </div>
    </div>

    <!-- Step indicator and controls -->
    <div class="flex items-center gap-4 pt-4 border-t border-white/[0.08]">
      <div class="flex gap-1.5">
        <button
          v-for="(step, idx) in steps"
          :key="step.id"
          class="w-2 h-2 rounded-full bg-white/[0.08] border-none cursor-pointer transition-all duration-300 hover:bg-[#6a6a80]"
          :class="{
            'bg-vue shadow-[0_0_8px_var(--color-vue)]': idx === currentStep,
            'bg-[#6a6a80]': idx < currentStep
          }"
          @click="goToStep(idx)"
        />
      </div>
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
