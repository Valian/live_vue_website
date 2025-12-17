<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from "vue"
import { useLiveVue } from "live_vue"

const props = defineProps<{
  question: string
  optionA: string
  optionB: string
  votesA: number
  votesB: number
  votingEndsAt: string
  winner: "a" | "b" | "draw" | null
}>()

const live = useLiveVue()

// Local state
const canVote = ref(true)
const lastVotedFor = ref<"a" | "b" | null>(null)
const countdown = ref(0)
const confettiParticles = ref<Array<{
  id: number
  x: number
  y: number
  vx: number
  vy: number
  rotation: number
  rotationSpeed: number
  color: string
  size: number
}>>([])

let countdownInterval: ReturnType<typeof setInterval> | null = null
let animationFrameId: number | null = null
let voteThrottleTimeout: ReturnType<typeof setTimeout> | null = null
let particleIdCounter = 0

// Computed
const totalVotes = computed(() => props.votesA + props.votesB)
const percentA = computed(() => (totalVotes.value > 0 ? (props.votesA / totalVotes.value) * 100 : 50))
const percentB = computed(() => (totalVotes.value > 0 ? (props.votesB / totalVotes.value) * 100 : 50))

const isVotingActive = computed(() => props.winner === null && countdown.value > 0)

// Update countdown from server timestamp
function updateCountdown() {
  const endTime = new Date(props.votingEndsAt).getTime()
  const now = Date.now()
  const remaining = Math.max(0, Math.ceil((endTime - now) / 1000))
  countdown.value = remaining
}

// Vote handler with local throttle
function vote(choice: "a" | "b") {
  if (!canVote.value || !isVotingActive.value) return

  live.pushEvent("poll_vote", { choice })
  lastVotedFor.value = choice
  canVote.value = false

  if (voteThrottleTimeout) clearTimeout(voteThrottleTimeout)
  voteThrottleTimeout = setTimeout(() => {
    canVote.value = true
  }, 3000)
}

// Confetti system
const confettiColors = [
  "#FD4F00", // phoenix
  "#FF8A50", // phoenix-glow
  "#42b883", // vue
  "#35495e", // vue-dark
  "#FFD700", // gold
  "#FF69B4", // pink
  "#00CED1", // cyan
]

function spawnConfetti() {
  const newParticles: typeof confettiParticles.value = []
  for (let i = 0; i < 100; i++) {
    newParticles.push({
      id: particleIdCounter++,
      x: Math.random() * 100,
      y: -10 - Math.random() * 20,
      vx: (Math.random() - 0.5) * 3,
      vy: Math.random() * 2 + 1,
      rotation: Math.random() * 360,
      rotationSpeed: (Math.random() - 0.5) * 10,
      color: confettiColors[Math.floor(Math.random() * confettiColors.length)],
      size: Math.random() * 8 + 4,
    })
  }
  confettiParticles.value = [...confettiParticles.value, ...newParticles]
}

function animateConfetti() {
  confettiParticles.value = confettiParticles.value
    .map((p) => ({
      ...p,
      x: p.x + p.vx * 0.1,
      y: p.y + p.vy * 0.3,
      vy: p.vy + 0.05, // gravity
      rotation: p.rotation + p.rotationSpeed,
    }))
    .filter((p) => p.y < 120) // remove particles that fell off screen

  if (confettiParticles.value.length > 0) {
    animationFrameId = requestAnimationFrame(animateConfetti)
  }
}

// Watch for winner to trigger confetti
watch(
  () => props.winner,
  (newWinner, oldWinner) => {
    if (newWinner && !oldWinner) {
      spawnConfetti()
      animateConfetti()
    }
    // Reset lastVotedFor when new round starts
    if (!newWinner && oldWinner) {
      lastVotedFor.value = null
    }
  }
)

// Lifecycle
onMounted(() => {
  updateCountdown()
  countdownInterval = setInterval(updateCountdown, 100)
})

onUnmounted(() => {
  if (countdownInterval) clearInterval(countdownInterval)
  if (animationFrameId) cancelAnimationFrame(animationFrameId)
  if (voteThrottleTimeout) clearTimeout(voteThrottleTimeout)
})
</script>

<template>
  <div
    class="relative flex flex-col gap-6 p-8 bg-[rgba(15,15,21,0.9)] border border-white/10 rounded-2xl backdrop-blur-xl min-w-[380px] max-w-[440px] overflow-hidden"
  >
    <!-- Confetti layer -->
    <div class="absolute inset-0 pointer-events-none overflow-hidden">
      <div
        v-for="particle in confettiParticles"
        :key="particle.id"
        class="absolute"
        :style="{
          left: `${particle.x}%`,
          top: `${particle.y}%`,
          width: `${particle.size}px`,
          height: `${particle.size * 0.6}px`,
          backgroundColor: particle.color,
          transform: `rotate(${particle.rotation}deg)`,
          borderRadius: '2px',
        }"
      />
    </div>

    <!-- Header -->
    <div class="text-center relative z-10">
      <div class="font-mono text-xs uppercase tracking-widest text-vue mb-3 flex items-center justify-center gap-2">
        <span class="w-1.5 h-1.5 rounded-full bg-vue animate-pulse" />
        Live Poll
      </div>
      <h3 class="font-serif text-2xl text-landing-text leading-tight">
        {{ question }}
      </h3>
    </div>

    <!-- Vote bars -->
    <div class="flex flex-col gap-3 relative z-10">
      <!-- Option A -->
      <button
        class="group relative flex items-center gap-4 p-4 rounded-xl border transition-all duration-200"
        :class="[
          winner === 'a'
            ? 'border-phoenix bg-phoenix/20'
            : winner
              ? 'border-white/5 bg-white/[0.02] opacity-60'
              : 'border-white/10 bg-white/[0.03] hover:border-phoenix/50 hover:bg-phoenix/10',
          !canVote && isVotingActive ? 'cursor-not-allowed' : 'cursor-pointer',
          lastVotedFor === 'a' && !winner ? 'ring-2 ring-phoenix/50' : '',
        ]"
        :disabled="!isVotingActive"
        @click="vote('a')"
      >
        <!-- Progress bar background -->
        <div
          class="absolute inset-0 rounded-xl transition-all duration-500 ease-out"
          :class="winner === 'a' ? 'bg-phoenix/30' : 'bg-phoenix/10'"
          :style="{ width: `${percentA}%` }"
        />

        <span class="relative z-10 font-medium text-landing-text text-lg flex-1 text-left">
          {{ optionA }}
        </span>

        <div class="relative z-10 flex items-center gap-2">
          <span class="font-mono text-sm text-landing-muted">{{ votesA }}</span>
          <span
            class="font-mono text-xs py-0.5 px-2 rounded bg-white/10"
            :class="winner === 'a' ? 'text-phoenix' : 'text-landing-muted'"
          >
            {{ Math.round(percentA) }}%
          </span>
        </div>

        <!-- Winner badge -->
        <div
          v-if="winner === 'a'"
          class="absolute -top-2 -right-2 py-1 px-2 bg-phoenix text-white text-xs font-bold uppercase tracking-wide rounded-full shadow-lg animate-bounce"
        >
          Winner!
        </div>
      </button>

      <!-- VS divider -->
      <div class="flex items-center gap-3 px-4">
        <div class="flex-1 h-px bg-white/10" />
        <span class="font-mono text-xs text-landing-muted uppercase tracking-wider">vs</span>
        <div class="flex-1 h-px bg-white/10" />
      </div>

      <!-- Option B -->
      <button
        class="group relative flex items-center gap-4 p-4 rounded-xl border transition-all duration-200"
        :class="[
          winner === 'b'
            ? 'border-vue bg-vue/20'
            : winner
              ? 'border-white/5 bg-white/[0.02] opacity-60'
              : 'border-white/10 bg-white/[0.03] hover:border-vue/50 hover:bg-vue/10',
          !canVote && isVotingActive ? 'cursor-not-allowed' : 'cursor-pointer',
          lastVotedFor === 'b' && !winner ? 'ring-2 ring-vue/50' : '',
        ]"
        :disabled="!isVotingActive"
        @click="vote('b')"
      >
        <!-- Progress bar background -->
        <div
          class="absolute inset-0 rounded-xl transition-all duration-500 ease-out origin-right"
          :class="winner === 'b' ? 'bg-vue/30' : 'bg-vue/10'"
          :style="{ width: `${percentB}%` }"
        />

        <span class="relative z-10 font-medium text-landing-text text-lg flex-1 text-left">
          {{ optionB }}
        </span>

        <div class="relative z-10 flex items-center gap-2">
          <span class="font-mono text-sm text-landing-muted">{{ votesB }}</span>
          <span
            class="font-mono text-xs py-0.5 px-2 rounded bg-white/10"
            :class="winner === 'b' ? 'text-vue' : 'text-landing-muted'"
          >
            {{ Math.round(percentB) }}%
          </span>
        </div>

        <!-- Winner badge -->
        <div
          v-if="winner === 'b'"
          class="absolute -top-2 -right-2 py-1 px-2 bg-vue text-white text-xs font-bold uppercase tracking-wide rounded-full shadow-lg animate-bounce"
        >
          Winner!
        </div>
      </button>
    </div>

    <!-- Draw state -->
    <div
      v-if="winner === 'draw'"
      class="text-center py-2 px-4 bg-white/5 border border-white/10 rounded-lg"
    >
      <span class="font-serif text-lg text-landing-text">It's a draw!</span>
    </div>

    <!-- Footer -->
    <div class="flex items-center justify-between pt-2 border-t border-white/10 relative z-10">
      <div class="flex items-center gap-2">
        <span class="font-mono text-xs text-landing-muted">
          {{ totalVotes }} vote{{ totalVotes === 1 ? "" : "s" }}
        </span>
      </div>

      <div class="flex items-center gap-2">
        <template v-if="winner">
          <span class="font-mono text-xs text-landing-muted">Next question in...</span>
        </template>
        <template v-else>
          <span
            v-if="!canVote"
            class="font-mono text-xs uppercase tracking-wide text-phoenix/70 py-0.5 px-2 bg-phoenix/10 rounded"
          >
            Wait 3s
          </span>
          <span class="font-mono text-xs text-landing-muted">Time left:</span>
        </template>
        <span
          class="font-mono text-sm font-semibold tabular-nums"
          :class="countdown <= 5 && !winner ? 'text-phoenix animate-pulse' : 'text-landing-text'"
        >
          {{ countdown }}s
        </span>
      </div>
    </div>

    <!-- Real-time indicator -->
    <div class="flex items-center justify-center gap-2 text-xs text-landing-muted">
      <span class="w-1 h-1 rounded-full bg-vue animate-pulse" />
      <span>Updates via PubSub - all users see votes in real-time</span>
    </div>
  </div>
</template>
