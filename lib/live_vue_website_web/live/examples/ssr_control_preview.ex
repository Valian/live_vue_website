defmodule LiveVueWebsiteWeb.Examples.SsrControlPreview do
  @moduledoc """
  Minimal SSR control demo LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
        <div class="text-sm font-medium text-landing-muted mb-3">
          With SSR (default)
        </div>
        <.vue
          v-component="examples/SsrControl"
          v-socket={@socket}
        />
      </div>

      <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
        <div class="text-sm font-medium text-landing-muted mb-3">
          Without SSR (v-ssr={false})
        </div>
        <.vue
          v-component="examples/SsrControl"
          v-socket={@socket}
          v-ssr={false}
        />
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end
end
