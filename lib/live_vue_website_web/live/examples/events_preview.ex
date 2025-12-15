defmodule LiveVueWebsiteWeb.Examples.EventsPreview do
  @moduledoc """
  Minimal events demo LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <.vue
      messages={@messages}
      v-component="examples/Events"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, messages: []), layout: false}
  end

  def handle_event("add_message", %{"text" => text}, socket) do
    message = %{id: System.unique_integer([:positive]), text: text, from: "pushEvent"}
    {:noreply, update(socket, :messages, &[message | &1])}
  end

  def handle_event("phx_click_message", %{"text" => text}, socket) do
    message = %{id: System.unique_integer([:positive]), text: text, from: "phx-click"}
    {:noreply, update(socket, :messages, &[message | &1])}
  end

  def handle_event("clear", _params, socket) do
    {:noreply, assign(socket, :messages, [])}
  end
end
