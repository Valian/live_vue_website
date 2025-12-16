defmodule LiveVueWebsiteWeb.Examples.ServerEventsPreview do
  @moduledoc """
  Minimal server events demo LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <.vue
      notification_count={@notification_count}
      v-component="examples/ServerEvents"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, notification_count: 0), layout: false}
  end

  def handle_event("trigger_notification", %{"type" => type}, socket) do
    notification = %{
      id: System.unique_integer([:positive]),
      type: type,
      message: notification_message(type),
      timestamp: System.system_time(:second)
    }

    {:noreply,
     socket
     |> push_event("notification", notification)
     |> update(:notification_count, &(&1 + 1))}
  end

  def handle_event("trigger_alert", %{"message" => message}, socket) do
    alert = %{
      id: System.unique_integer([:positive]),
      message: message,
      timestamp: System.system_time(:second)
    }

    {:noreply, push_event(socket, "alert", alert)}
  end

  defp notification_message("info"), do: "This is an informational notification"
  defp notification_message("success"), do: "Operation completed successfully!"
  defp notification_message("warning"), do: "Please review your settings"
  defp notification_message("error"), do: "An error occurred, please try again"
  defp notification_message(_), do: "New notification"
end
