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
  <div class="flow-hero">
    <div class="flow-layout">
      <!-- Main column with layers -->
      <div class="layers-column">
        <!-- SERVER LAYER -->
        <div
          class="layer layer-server"
          :class="{
            'layer-active': steps[currentStep].highlight === 'server' || steps[currentStep].highlight === 'server-update'
          }"
        >
          <div class="layer-badge">Server</div>
          <div class="layer-title">
            <svg class="layer-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <rect x="2" y="3" width="20" height="6" rx="1" />
              <rect x="2" y="11" width="20" height="6" rx="1" />
              <circle cx="6" cy="6" r="1" fill="currentColor" />
              <circle cx="6" cy="14" r="1" fill="currentColor" />
            </svg>
            LiveView
          </div>
          <div class="layer-code">
            <span class="code-comment"># assigns</span>
            <span class="code-line">
              <span class="code-key">@count</span>
              <span class="code-punct"> = </span>
              <span
                class="code-value"
                :class="{ 'value-glow': steps[currentStep].highlight === 'server-update' }"
              >{{ serverCount }}</span>
            </span>
          </div>
        </div>

        <!-- Connection: Server to Vue -->
        <div class="connection">
          <div class="connection-line" :class="{ 'line-active': steps[currentStep].highlight === 'props' }"></div>
          <div
            v-if="dotAnimation === 'down'"
            :key="'down-' + currentStep"
            class="flow-dot dot-down"
          ></div>
          <div
            class="connection-label"
            :class="{ 'label-active': steps[currentStep].highlight === 'props' }"
          >
            <span class="label-text">props</span>
            <svg class="label-arrow" viewBox="0 0 12 12">
              <path d="M6 0 L6 10 M2 6 L6 10 L10 6" stroke="currentColor" fill="none" stroke-width="2"/>
            </svg>
          </div>
        </div>

        <!-- VUE LAYER -->
        <div
          class="layer layer-vue"
          :class="{ 'layer-active': steps[currentStep].highlight === 'render' || steps[currentStep].highlight === 'props' }"
        >
          <div class="layer-badge">Client</div>
          <div class="layer-title">
            <svg class="layer-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <polygon points="12,2 22,8.5 22,15.5 12,22 2,15.5 2,8.5" />
              <polygon points="12,6 17,9 17,15 12,18 7,15 7,9" fill="currentColor" opacity="0.3" />
            </svg>
            Vue Component
          </div>
          <div class="layer-code">
            <span class="code-comment">// props from server</span>
            <span class="code-line">
              <span class="code-key">count</span>
              <span class="code-punct">: </span>
              <span
                class="code-value"
                :class="{ 'value-glow': steps[currentStep].highlight === 'props' }"
              >{{ serverCount }}</span>
            </span>
          </div>
        </div>

        <!-- Connection: Vue to DOM -->
        <div class="connection">
          <div class="connection-line" :class="{ 'line-active line-vue': steps[currentStep].highlight === 'render' || steps[currentStep].highlight === 'dom' }"></div>
          <div
            v-if="dotAnimation === 'render'"
            :key="'render-' + currentStep"
            class="flow-dot dot-render"
          ></div>
          <div
            class="connection-label label-right"
            :class="{ 'label-active label-vue': steps[currentStep].highlight === 'render' || steps[currentStep].highlight === 'dom' }"
          >
            <span class="label-text">render</span>
            <svg class="label-arrow" viewBox="0 0 12 12">
              <path d="M6 0 L6 10 M2 6 L6 10 L10 6" stroke="currentColor" fill="none" stroke-width="2"/>
            </svg>
          </div>
        </div>

        <!-- DOM LAYER -->
        <div
          class="layer layer-dom"
          :class="{
            'layer-active': steps[currentStep].highlight === 'dom' || steps[currentStep].highlight === 'dom-button'
          }"
        >
          <div class="layer-badge">Browser</div>
          <div class="layer-title">
            <svg class="layer-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
              <rect x="3" y="4" width="18" height="14" rx="2"/>
              <line x1="3" y1="9" x2="21" y2="9"/>
              <circle cx="6" cy="6.5" r="0.75" fill="currentColor"/>
              <circle cx="9" cy="6.5" r="0.75" fill="currentColor"/>
            </svg>
            Rendered DOM
          </div>
          <div class="dom-preview">
            <div class="dom-counter">
              <span
                class="dom-count"
                :class="{ 'value-glow': steps[currentStep].highlight === 'dom' }"
              >{{ serverCount }}</span>
              <button
                class="dom-button"
                :class="{ 'button-highlight': steps[currentStep].highlight === 'dom-button' }"
              >
                <span class="dom-button-plus">+</span>
              </button>
            </div>
            <div class="dom-attr" :class="{ 'attr-highlight': steps[currentStep].highlight === 'dom-button' }">
              phx-click="inc"
            </div>
          </div>
        </div>
      </div>

      <!-- Event path column (right side) -->
      <div class="event-column" :class="{ 'event-active': steps[currentStep].highlight === 'event' }">
        <div class="event-line"></div>
        <div
          v-if="dotAnimation === 'up'"
          :key="'up-' + currentStep"
          class="flow-dot dot-up"
        ></div>
        <div class="event-label" :class="{ 'label-active': steps[currentStep].highlight === 'event' }">
          <svg class="label-arrow" viewBox="0 0 12 12">
            <path d="M6 12 L6 2 M2 6 L6 2 L10 6" stroke="currentColor" fill="none" stroke-width="2"/>
          </svg>
          <span class="label-text">event</span>
        </div>
        <!-- Connection indicators -->
        <div class="event-connector event-connector-top"></div>
        <div class="event-connector event-connector-bottom"></div>
      </div>
    </div>

    <!-- Step indicator and controls -->
    <div class="status-bar">
      <div class="step-dots">
        <button
          v-for="(step, idx) in steps"
          :key="step.id"
          class="step-dot"
          :class="{ 'dot-active': idx === currentStep, 'dot-past': idx < currentStep }"
          @click="goToStep(idx)"
        />
      </div>
      <div class="step-info">
        <span class="step-label">{{ steps[currentStep].label }}</span>
        <span class="step-desc">{{ steps[currentStep].desc }}</span>
      </div>
      <button class="play-toggle" @click="toggleAnimation">
        <svg v-if="isAnimating" viewBox="0 0 24 24" fill="currentColor">
          <rect x="6" y="4" width="4" height="16" rx="1" />
          <rect x="14" y="4" width="4" height="16" rx="1" />
        </svg>
        <svg v-else viewBox="0 0 24 24" fill="currentColor">
          <polygon points="5,3 19,12 5,21" />
        </svg>
      </button>
    </div>

    <!-- Legend -->
    <div class="legend">
      <div class="legend-item">
        <span class="legend-dot legend-phoenix"></span>
        <span>Phoenix/Server</span>
      </div>
      <div class="legend-item">
        <span class="legend-dot legend-vue"></span>
        <span>Vue/Client</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.flow-hero {
  --phoenix: #FD4F00;
  --phoenix-glow: rgba(253, 79, 0, 0.4);
  --vue: #42b883;
  --vue-glow: rgba(66, 184, 131, 0.4);
  --bg: rgba(10, 10, 15, 0.95);
  --bg-layer: rgba(20, 20, 28, 0.9);
  --border: rgba(255, 255, 255, 0.08);
  --border-active: rgba(255, 255, 255, 0.2);
  --text: #f0f0f5;
  --text-muted: #6a6a80;

  display: flex;
  flex-direction: column;
  gap: 1.25rem;
  padding: 1.75rem;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: 16px;
  backdrop-filter: blur(20px);
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.8rem;
  width: 480px;
}

/* Main layout - layers + event column */
.flow-layout {
  display: flex;
  gap: 1.5rem;
}

.layers-column {
  flex: 1;
  display: flex;
  flex-direction: column;
}

/* Individual Layers */
.layer {
  padding: 1rem 1.25rem;
  border-radius: 10px;
  border: 1px solid var(--border);
  background: var(--bg-layer);
  transition: border-color 0.4s, box-shadow 0.4s;
  position: relative;
}

.layer-active.layer-server {
  border-color: var(--phoenix);
  box-shadow: 0 0 25px var(--phoenix-glow), inset 0 0 20px rgba(253, 79, 0, 0.05);
}

.layer-active.layer-vue {
  border-color: var(--vue);
  box-shadow: 0 0 25px var(--vue-glow), inset 0 0 20px rgba(66, 184, 131, 0.05);
}

.layer-active.layer-dom {
  border-color: var(--vue);
  box-shadow: 0 0 25px var(--vue-glow), inset 0 0 20px rgba(66, 184, 131, 0.05);
}

.layer-badge {
  position: absolute;
  top: -8px;
  right: 12px;
  font-size: 0.6rem;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  padding: 0.15rem 0.5rem;
  border-radius: 4px;
  background: var(--bg);
  border: 1px solid var(--border);
  color: var(--text-muted);
}

.layer-title {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--text);
  margin-bottom: 0.75rem;
}

.layer-icon {
  width: 18px;
  height: 18px;
}

.layer-server .layer-icon {
  color: var(--phoenix);
}

.layer-vue .layer-icon,
.layer-dom .layer-icon {
  color: var(--vue);
}

.layer-code {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding: 0.6rem 0.75rem;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 6px;
}

.code-comment {
  color: var(--text-muted);
  font-size: 0.7rem;
}

.code-line {
  display: flex;
  gap: 0.25rem;
}

.code-key { color: #e06c75; }
.code-punct { color: var(--text-muted); }
.code-value {
  color: #d19a66;
  transition: all 0.3s;
}

.value-glow {
  color: #fff;
  text-shadow: 0 0 12px currentColor, 0 0 24px currentColor;
}

/* DOM Preview */
.dom-preview {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
  padding: 1rem;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 6px;
}

.dom-counter {
  display: flex;
  align-items: center;
  gap: 1rem;
}

.dom-count {
  font-family: 'Instrument Serif', Georgia, serif;
  font-size: 2.5rem;
  color: var(--text);
  transition: all 0.3s;
  min-width: 2ch;
  text-align: center;
}

.dom-button {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  border: 1px solid var(--border);
  background: rgba(253, 79, 0, 0.1);
  color: var(--phoenix);
  font-size: 1.5rem;
  cursor: default;
  transition: all 0.3s;
}

.button-highlight {
  border-color: var(--phoenix);
  box-shadow: 0 0 15px var(--phoenix-glow);
  transform: scale(1.1);
}

.dom-button-plus {
  line-height: 1;
}

.dom-attr {
  font-size: 0.65rem;
  color: var(--text-muted);
  padding: 0.25rem 0.6rem;
  background: rgba(0, 0, 0, 0.3);
  border-radius: 4px;
  transition: all 0.3s;
}

.attr-highlight {
  color: var(--phoenix);
  background: rgba(253, 79, 0, 0.15);
}

/* Connections (vertical) */
.connection {
  position: relative;
  height: 44px;
  display: flex;
  justify-content: center;
  align-items: center;
}

.connection-line {
  width: 2px;
  height: 100%;
  background: var(--border);
  transition: background 0.4s, box-shadow 0.4s;
}

.line-active {
  background: var(--phoenix);
  box-shadow: 0 0 8px var(--phoenix-glow);
}

.line-active.line-vue {
  background: var(--vue);
  box-shadow: 0 0 8px var(--vue-glow);
}

/* Connection Labels */
.connection-label {
  position: absolute;
  left: calc(50% + 15px);
  display: flex;
  align-items: center;
  gap: 0.35rem;
  padding: 0.25rem 0.6rem;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: 4px;
  font-size: 0.65rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-muted);
  transition: all 0.4s;
}

.connection-label.label-right {
  left: auto;
  right: calc(50% + 15px);
}

.label-active {
  color: var(--phoenix);
  border-color: var(--phoenix);
  box-shadow: 0 0 10px var(--phoenix-glow);
}

.label-active.label-vue {
  color: var(--vue);
  border-color: var(--vue);
  box-shadow: 0 0 10px var(--vue-glow);
}

.label-arrow {
  width: 10px;
  height: 10px;
}

/* Flow dots with CSS animations */
.flow-dot {
  position: absolute;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  left: 50%;
  transform: translateX(-50%);
  z-index: 10;
}

.dot-down {
  background: var(--phoenix);
  box-shadow: 0 0 10px var(--phoenix), 0 0 20px var(--phoenix);
  animation: flow-down 1.5s ease-in-out forwards;
}

.dot-render {
  background: var(--vue);
  box-shadow: 0 0 10px var(--vue), 0 0 20px var(--vue);
  animation: flow-down 1s ease-in-out forwards;
}

@keyframes flow-down {
  0% {
    top: 0;
    opacity: 1;
  }
  100% {
    top: calc(100% - 10px);
    opacity: 1;
  }
}

/* Event column (right side) */
.event-column {
  width: 50px;
  position: relative;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.event-line {
  position: absolute;
  top: 20px;
  bottom: 20px;
  width: 2px;
  background: var(--border);
  transition: background 0.4s, box-shadow 0.4s;
}

.event-active .event-line {
  background: var(--vue);
  box-shadow: 0 0 8px var(--vue-glow);
}

/* Horizontal connectors from event line to layers */
.event-connector {
  position: absolute;
  height: 2px;
  width: 20px;
  right: 24px;
  background: var(--border);
  transition: background 0.4s;
}

.event-connector-top {
  top: 20px;
}

.event-connector-bottom {
  bottom: 20px;
}

.event-active .event-connector {
  background: var(--vue);
}

.dot-up {
  position: absolute;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  left: 50%;
  transform: translateX(-50%);
  background: var(--vue);
  box-shadow: 0 0 10px var(--vue), 0 0 20px var(--vue);
  animation: flow-up 1.5s ease-in-out forwards;
  z-index: 10;
}

@keyframes flow-up {
  0% {
    bottom: 20px;
    opacity: 1;
  }
  100% {
    bottom: calc(100% - 30px);
    opacity: 1;
  }
}

.event-label {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.25rem;
  padding: 0.3rem 0.5rem;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: 4px;
  font-size: 0.6rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--text-muted);
  transition: all 0.4s;
  z-index: 5;
}

.event-label.label-active {
  color: var(--vue);
  border-color: var(--vue);
  box-shadow: 0 0 10px var(--vue-glow);
}

/* Status Bar */
.status-bar {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding-top: 1rem;
  border-top: 1px solid var(--border);
}

.step-dots {
  display: flex;
  gap: 0.4rem;
}

.step-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: var(--border);
  border: none;
  cursor: pointer;
  transition: all 0.3s;
}

.step-dot:hover {
  background: var(--text-muted);
}

.dot-past {
  background: var(--text-muted);
}

.dot-active {
  background: var(--vue);
  box-shadow: 0 0 8px var(--vue);
}

.step-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
}

.step-label {
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--text);
}

.step-desc {
  font-size: 0.65rem;
  color: var(--text-muted);
}

.play-toggle {
  width: 28px;
  height: 28px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(255, 255, 255, 0.05);
  border: 1px solid var(--border);
  border-radius: 6px;
  color: var(--text-muted);
  cursor: pointer;
  transition: all 0.2s;
}

.play-toggle:hover {
  color: var(--text);
  border-color: var(--text-muted);
}

.play-toggle svg {
  width: 12px;
  height: 12px;
}

/* Legend */
.legend {
  display: flex;
  justify-content: center;
  gap: 1.5rem;
  font-size: 0.65rem;
  color: var(--text-muted);
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 0.4rem;
}

.legend-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
}

.legend-phoenix {
  background: var(--phoenix);
  box-shadow: 0 0 6px var(--phoenix-glow);
}

.legend-vue {
  background: var(--vue);
  box-shadow: 0 0 6px var(--vue-glow);
}
</style>
