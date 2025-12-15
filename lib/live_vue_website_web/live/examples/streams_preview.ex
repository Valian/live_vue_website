defmodule LiveVueWebsiteWeb.Examples.StreamsPreview do
  @moduledoc """
  Minimal streams chat LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  @ai_responses [
    "That's an interesting point! I'd love to hear more about your thoughts.",
    "I see what you mean. Have you considered looking at it from a different angle?",
    "Great question! Let me think about that for a moment...",
    "Thanks for sharing! This reminds me of something I read recently.",
    "I appreciate your curiosity. The answer might surprise you!"
  ]

  def render(assigns) do
    ~H"""
    <.vue
      messages={@streams.messages}
      isThinking={@is_thinking}
      v-component="examples/Streams"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    welcome = %{
      id: Ecto.UUID.generate(),
      role: "assistant",
      content: "Hi! I'm a demo AI. Send me a message and I'll respond."
    }

    {:ok,
     socket
     |> assign(is_thinking: false)
     |> stream(:messages, [welcome]), layout: false}
  end

  def handle_event("send_message", %{"content" => content}, socket) do
    content = String.trim(content)

    if content == "" do
      {:noreply, socket}
    else
      user_message = %{id: Ecto.UUID.generate(), role: "user", content: content}

      socket =
        socket
        |> stream_insert(:messages, user_message)
        |> assign(is_thinking: true)
        |> start_async(:ai_response, fn ->
          Process.sleep(Enum.random(800..1500))
          Enum.random(@ai_responses)
        end)

      {:noreply, socket}
    end
  end

  def handle_async(:ai_response, {:ok, response}, socket) do
    ai_message = %{id: Ecto.UUID.generate(), role: "assistant", content: response}

    {:noreply,
     socket
     |> stream_insert(:messages, ai_message)
     |> assign(is_thinking: false)}
  end

  def handle_async(:ai_response, {:exit, _reason}, socket) do
    {:noreply, assign(socket, is_thinking: false)}
  end
end
