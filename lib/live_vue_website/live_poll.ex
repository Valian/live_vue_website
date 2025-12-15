defmodule LiveVueWebsite.LivePoll do
  @moduledoc """
  GenServer that manages a live polling system with rotating questions.

  Each round lasts 30 seconds:
  - 25 seconds of voting
  - 5 seconds showing winner with confetti

  State is broadcast via PubSub to all connected LiveViews.
  """
  use GenServer

  alias Phoenix.PubSub

  @pubsub LiveVueWebsite.PubSub
  @topic "live_poll"
  @voting_duration_ms 25_000
  @winner_display_ms 5_000

  @questions [
    {"Tabs or Spaces?", "Tabs", "Spaces"},
    {"Light mode or Dark mode?", "Light", "Dark"},
    {"Elixir or Ruby?", "Elixir", "Ruby"},
    {"Coffee or Tea?", "Coffee", "Tea"},
    {"Monolith or Microservices?", "Monolith", "Microservices"},
    {"REST or GraphQL?", "REST", "GraphQL"},
    {"Vim or Emacs?", "Vim", "Emacs"},
    {"Dogs or Cats?", "Dogs", "Cats"},
    {"Morning person or Night owl?", "Morning", "Night owl"},
    {"Phoenix or Rails?", "Phoenix", "Rails"},
    {"Types or No types?", "Types", "No types"},
    {"Rebase or Merge?", "Rebase", "Merge"},
    {"OOP or FP?", "OOP", "FP"},
    {"Mac or Linux?", "Mac", "Linux"},
    {"React or Vue?", "React", "Vue"}
  ]

  # Client API

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @doc """
  Get the current poll state.
  Returns a map with: question, option_a, option_b, votes_a, votes_b, voting_ends_at, winner
  """
  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  @doc """
  Cast a vote for option "a" or "b".
  """
  def vote(choice) when choice in ["a", "b"] do
    GenServer.cast(__MODULE__, {:vote, choice})
  end

  @doc """
  Subscribe to poll updates.
  """
  def subscribe do
    PubSub.subscribe(@pubsub, @topic)
  end

  # Server callbacks

  @impl true
  def init(_opts) do
    state = start_new_round(%{question_index: 0})
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, public_state(state), state}
  end

  @impl true
  def handle_cast({:vote, choice}, state) do
    # Only accept votes during voting phase (winner is nil)
    if state.winner == nil do
      key = if choice == "a", do: :votes_a, else: :votes_b
      new_state = Map.update!(state, key, &(&1 + 1))
      broadcast(new_state)
      {:noreply, new_state}
    else
      {:noreply, state}
    end
  end

  @impl true
  def handle_info(:end_voting, state) do
    winner =
      cond do
        state.votes_a > state.votes_b -> "a"
        state.votes_b > state.votes_a -> "b"
        true -> "draw"
      end

    new_state = %{state | winner: winner}
    broadcast(new_state)

    # Schedule next round after winner display
    Process.send_after(self(), :next_round, @winner_display_ms)

    {:noreply, new_state}
  end

  @impl true
  def handle_info(:next_round, state) do
    next_index = rem(state.question_index + 1, length(@questions))
    new_state = start_new_round(%{question_index: next_index})
    broadcast(new_state)
    {:noreply, new_state}
  end

  # Private functions

  defp start_new_round(%{question_index: index}) do
    {question, option_a, option_b} = Enum.at(@questions, index)
    voting_ends_at = DateTime.add(DateTime.utc_now(), @voting_duration_ms, :millisecond)

    # Schedule end of voting
    Process.send_after(self(), :end_voting, @voting_duration_ms)

    %{
      question_index: index,
      question: question,
      option_a: option_a,
      option_b: option_b,
      votes_a: 0,
      votes_b: 0,
      voting_ends_at: voting_ends_at,
      winner: nil
    }
  end

  defp public_state(state) do
    %{
      question: state.question,
      option_a: state.option_a,
      option_b: state.option_b,
      votes_a: state.votes_a,
      votes_b: state.votes_b,
      voting_ends_at: DateTime.to_iso8601(state.voting_ends_at),
      winner: state.winner
    }
  end

  defp broadcast(state) do
    PubSub.broadcast(@pubsub, @topic, {:poll_update, public_state(state)})
  end
end
