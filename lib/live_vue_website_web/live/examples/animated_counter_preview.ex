defmodule LiveVueWebsiteWeb.Examples.AnimatedCounterPreview do
  @moduledoc """
  Minimal animated counter LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <.vue
      count={@count}
      v-component="examples/AnimatedCounter"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0), layout: false}
  end

  def handle_event("inc", %{"diff" => diff}, socket) do
    {:noreply, update(socket, :count, &(&1 + String.to_integer(diff)))}
  end

  def handle_event("inc", _params, socket) do
    {:noreply, update(socket, :count, &(&1 - 1))}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, assign(socket, :count, 0)}
  end
end
