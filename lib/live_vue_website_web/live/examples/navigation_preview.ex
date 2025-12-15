defmodule LiveVueWebsiteWeb.Examples.NavigationPreview do
  @moduledoc """
  Navigation demo LiveView showing handle_params usage.
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
    {:ok, socket, layout: false}
  end

  def handle_params(params, uri, socket) do
    %URI{path: path} = URI.parse(uri)

    {:noreply,
     assign(socket,
       current_path: path,
       query_params: params
     )}
  end
end
