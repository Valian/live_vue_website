defmodule LiveVueWebsiteWeb.Examples.InjectPreview do
  @moduledoc """
  Demonstrates v-inject: a layout component rendered separately,
  with a page component injected into its slot.
  """
  use LiveVueWebsiteWeb, :live_view

  @messages [
    "Hello from the injected page!",
    "v-inject fills the layout slot",
    "Layout persists across navigation",
    "Only the page content changes"
  ]

  def render(assigns) do
    ~H"""
    <div class="space-y-4">
      <.vue
        id="app-layout"
        v-component="examples/InjectLayout"
        v-socket={@socket}
        title="My App"
        theme={@theme}
      />

      <.vue
        v-component="examples/Inject"
        v-socket={@socket}
        v-inject="app-layout"
        message={@message}
      />

      <div class="flex gap-2">
        <button phx-click="toggle_theme" class="btn btn-sm btn-outline">
          Toggle theme
        </button>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, theme: "light", message: hd(@messages), message_index: 0), layout: false}
  end

  def handle_event("toggle_theme", _params, socket) do
    theme = if socket.assigns.theme == "light", do: "dark", else: "light"
    {:noreply, assign(socket, :theme, theme)}
  end

  def handle_event("change_message", _params, socket) do
    index = rem(socket.assigns.message_index + 1, length(@messages))
    {:noreply, assign(socket, message: Enum.at(@messages, index), message_index: index)}
  end
end
