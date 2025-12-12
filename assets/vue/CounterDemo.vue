<script setup lang="ts">
import { ref } from 'vue'

const props = defineProps<{
  count: number
}>()

// Local Vue state - doesn't hit the server
const diff = ref(1)
const lastAction = ref<string | null>(null)

function showAction(action: string) {
  lastAction.value = action
  setTimeout(() => {
    lastAction.value = null
  }, 1500)
}
</script>

<template>
  <div class="counter-demo">
    <div class="demo-display">
      <div class="count-label">Server State</div>
      <div class="count-value" :key="count">
        {{ count }}
      </div>
      <div class="count-source">@count from LiveView assigns</div>
    </div>

    <div class="demo-controls">
      <div class="slider-section">
        <label class="slider-label">
          <span>Increment by:</span>
          <span class="slider-value">{{ diff }}</span>
        </label>
        <input
          v-model.number="diff"
          type="range"
          min="1"
          max="10"
          class="slider"
        />
        <div class="slider-hint">Local Vue state — no server round-trip</div>
      </div>

      <div class="button-section">
        <button
          class="btn btn-increment"
          phx-click="inc"
          :phx-value-diff="diff"
          @click="showAction(`+${diff}`)"
        >
          <span class="btn-icon">+</span>
          <span class="btn-text">{{ diff }}</span>
        </button>

        <button
          class="btn btn-decrement"
          phx-click="dec"
          @click="showAction('-1')"
        >
          <span class="btn-icon">−</span>
          <span class="btn-text">1</span>
        </button>

        <button
          class="btn btn-reset"
          phx-click="reset"
          @click="showAction('reset')"
        >
          <span class="btn-text">Reset</span>
        </button>
      </div>

      <div class="action-hint" :class="{ 'hint-visible': lastAction }">
        <span class="hint-badge">phx-click</span>
        {{ lastAction === 'reset' ? 'Sent "reset" event' : `Sent "inc" with diff=${lastAction?.replace('+', '')}` }}
      </div>
    </div>
  </div>
</template>

<style scoped>
.counter-demo {
  --phoenix: #FD4F00;
  --phoenix-glow: rgba(253, 79, 0, 0.3);
  --vue: #42b883;
  --vue-glow: rgba(66, 184, 131, 0.3);
  --bg: rgba(15, 15, 21, 0.9);
  --bg-elevated: rgba(26, 26, 36, 0.9);
  --border: rgba(255, 255, 255, 0.1);
  --text: #f0f0f5;
  --text-muted: #8888a0;

  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  padding: 2rem;
  background: var(--bg);
  border: 1px solid var(--border);
  border-radius: 16px;
  backdrop-filter: blur(20px);
  min-width: 320px;
  max-width: 380px;
}

/* Display Section */
.demo-display {
  text-align: center;
  padding: 2rem 1rem;
  background: linear-gradient(135deg, rgba(253, 79, 0, 0.05) 0%, rgba(66, 184, 131, 0.05) 100%);
  border: 1px solid var(--border);
  border-radius: 12px;
}

.count-label {
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.1em;
  color: var(--phoenix);
  margin-bottom: 0.5rem;
}

.count-value {
  font-family: 'Instrument Serif', Georgia, serif;
  font-size: 5rem;
  font-weight: 400;
  line-height: 1;
  color: var(--text);
  transition: transform 0.2s, color 0.2s;
  animation: count-pop 0.3s ease-out;
}

@keyframes count-pop {
  0% { transform: scale(1.1); color: var(--phoenix); }
  100% { transform: scale(1); color: var(--text); }
}

.count-source {
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.65rem;
  color: var(--text-muted);
  margin-top: 0.75rem;
}

/* Controls Section */
.demo-controls {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.slider-section {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.slider-label {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 0.85rem;
  color: var(--text);
}

.slider-value {
  font-family: 'JetBrains Mono', monospace;
  font-weight: 600;
  color: var(--vue);
  background: rgba(66, 184, 131, 0.1);
  padding: 0.2rem 0.5rem;
  border-radius: 4px;
}

.slider {
  -webkit-appearance: none;
  appearance: none;
  width: 100%;
  height: 6px;
  background: var(--bg-elevated);
  border-radius: 3px;
  outline: none;
  cursor: pointer;
}

.slider::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 20px;
  height: 20px;
  background: var(--vue);
  border-radius: 50%;
  cursor: pointer;
  box-shadow: 0 2px 8px var(--vue-glow);
  transition: transform 0.2s, box-shadow 0.2s;
}

.slider::-webkit-slider-thumb:hover {
  transform: scale(1.15);
  box-shadow: 0 4px 16px var(--vue-glow);
}

.slider::-moz-range-thumb {
  width: 20px;
  height: 20px;
  background: var(--vue);
  border: none;
  border-radius: 50%;
  cursor: pointer;
  box-shadow: 0 2px 8px var(--vue-glow);
}

.slider-hint {
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.6rem;
  color: var(--text-muted);
  text-align: center;
}

/* Buttons */
.button-section {
  display: grid;
  grid-template-columns: 1fr 1fr 1fr;
  gap: 0.75rem;
}

.btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 0.25rem;
  padding: 1rem;
  border: 1px solid var(--border);
  border-radius: 10px;
  background: var(--bg-elevated);
  color: var(--text);
  font-family: inherit;
  cursor: pointer;
  transition: transform 0.15s, border-color 0.15s, background 0.15s, box-shadow 0.15s;
}

.btn:hover {
  transform: translateY(-2px);
}

.btn:active {
  transform: translateY(0);
}

.btn-icon {
  font-size: 1.5rem;
  font-weight: 300;
  line-height: 1;
}

.btn-text {
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.7rem;
  color: var(--text-muted);
}

.btn-increment {
  border-color: var(--phoenix);
  background: rgba(253, 79, 0, 0.1);
}

.btn-increment:hover {
  background: rgba(253, 79, 0, 0.2);
  box-shadow: 0 4px 20px var(--phoenix-glow);
}

.btn-increment .btn-icon {
  color: var(--phoenix);
}

.btn-decrement:hover {
  border-color: var(--text-muted);
  background: rgba(255, 255, 255, 0.05);
}

.btn-reset {
  font-size: 0.75rem;
}

.btn-reset:hover {
  border-color: var(--text-muted);
  background: rgba(255, 255, 255, 0.05);
}

.btn-reset .btn-text {
  color: var(--text);
}

/* Action Hint */
.action-hint {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1rem;
  background: rgba(253, 79, 0, 0.1);
  border: 1px solid rgba(253, 79, 0, 0.2);
  border-radius: 8px;
  font-size: 0.75rem;
  color: var(--text-muted);
  opacity: 0;
  transform: translateY(8px);
  transition: opacity 0.3s, transform 0.3s;
}

.hint-visible {
  opacity: 1;
  transform: translateY(0);
}

.hint-badge {
  font-family: 'JetBrains Mono', monospace;
  font-size: 0.6rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  padding: 0.2rem 0.4rem;
  background: var(--phoenix);
  color: white;
  border-radius: 3px;
  font-weight: 600;
}
</style>
