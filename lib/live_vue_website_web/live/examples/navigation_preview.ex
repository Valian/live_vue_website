defmodule LiveVueWebsiteWeb.Examples.NavigationPreview do
  @moduledoc """
  Minimal navigation demo LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <.vue
      current_path={@current_path}
      query_params={@query_params}
      v-component="examples/Navigation"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_path: "/examples/navigation", query_params: %{}), layout: false}
  end

  def handle_event("update_location", %{"path" => path, "query" => query}, socket) do
    {:noreply, assign(socket, current_path: path, query_params: query)}
  end
end
