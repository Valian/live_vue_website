defmodule LiveVueWebsiteWeb.Examples.SharedPropsPreview do
  @moduledoc """
  Demonstrates headless shared props: a .vue component without v-component
  acts as a state provider, and another component reads from it via useLiveVue().
  """
  use LiveVueWebsiteWeb, :live_view

  @users [
    %{name: "Alice", role: "Engineer"},
    %{name: "Bob", role: "Designer"},
    %{name: "Carol", role: "Product Manager"}
  ]

  def render(assigns) do
    ~H"""
    <div class="space-y-4">
      <.vue
        id="shared-state"
        v-socket={@socket}
        user={@user}
        theme={@theme}
      />

      <.vue
        v-component="examples/SharedProps"
        v-socket={@socket}
        pageTitle="Dashboard"
      />

      <div class="flex gap-2">
        <button phx-click="toggle_theme" class="btn btn-sm btn-outline">
          Toggle theme
        </button>
        <button phx-click="cycle_user" class="btn btn-sm btn-outline">
          Switch user
        </button>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, theme: "light", user: hd(@users), user_index: 0), layout: false}
  end

  def handle_event("toggle_theme", _params, socket) do
    theme = if socket.assigns.theme == "light", do: "dark", else: "light"
    {:noreply, assign(socket, :theme, theme)}
  end

  def handle_event("cycle_user", _params, socket) do
    index = rem(socket.assigns.user_index + 1, length(@users))
    {:noreply, assign(socket, user: Enum.at(@users, index), user_index: index)}
  end
end
