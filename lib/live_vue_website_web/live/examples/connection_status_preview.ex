defmodule LiveVueWebsiteWeb.Examples.ConnectionStatusPreview do
  @moduledoc """
  Minimal ConnectionStatus LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <.vue
      v-component="examples/ConnectionStatus"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end
end
