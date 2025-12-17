defmodule LiveVueWebsiteWeb.Examples.SigilPreview do
  @moduledoc """
  Minimal Vue sigil demo LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view
  use LiveVue

  @emojis ~w(rocket fire star sparkles zap rainbow heart pizza)

  def render(assigns) do
    ~VUE"""
    <script setup lang="ts">
    import { computed } from 'vue'

    const props = defineProps<{
      emoji: string
      votes: number
    }>()

    const emojiMap: Record<string, string> = {
      rocket: '🚀', fire: '🔥', star: '⭐', sparkles: '✨',
      zap: '⚡', rainbow: '🌈', heart: '❤️', pizza: '🍕'
    }

    const display = computed(() => emojiMap[props.emoji] || '❓')
    </script>

    <template>
      <div class="text-center">
        <div class="text-6xl mb-4 transition-all hover:scale-125" :title="emoji">
          {{ display }}
        </div>
        <div class="text-2xl font-mono font-bold text-landing-text mb-4">
          {{ votes }} votes
        </div>
        <div class="flex gap-2 justify-center flex-wrap">
          <button
            phx-click="vote"
            class="py-2 px-4 bg-gradient-to-br from-phoenix to-phoenix-glow text-white rounded-lg font-medium shadow-lg shadow-phoenix/20 hover:-translate-y-0.5 transition-all"
          >
            Vote!
          </button>
          <button
            phx-click="shuffle"
            class="py-2 px-4 bg-landing-elevated border border-landing-border text-landing-text rounded-lg font-medium hover:bg-landing-card transition-all"
          >
            Shuffle
          </button>
        </div>
      </div>
    </template>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       emoji: Enum.random(@emojis),
       votes: 0
     ), layout: false}
  end

  def handle_event("vote", _params, socket) do
    {:noreply, update(socket, :votes, &(&1 + 1))}
  end

  def handle_event("shuffle", _params, socket) do
    {:noreply, assign(socket, emoji: Enum.random(@emojis))}
  end
end
