defmodule LiveVueWebsite.GitHubStars do
  @moduledoc """
  Fetches and caches GitHub stars count for the live_vue repository.
  """

  use GenServer

  @repo "Valian/live_vue"
  @fallback_stars 430
  @refresh_interval :timer.minutes(10)

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def get_stars do
    GenServer.call(__MODULE__, :get_stars)
  end

  @impl true
  def init(_) do
    stars = fetch_stars()
    schedule_refresh()
    {:ok, %{stars: stars}}
  end

  @impl true
  def handle_call(:get_stars, _from, state) do
    {:reply, state.stars, state}
  end

  @impl true
  def handle_info(:refresh, state) do
    stars = fetch_stars(state.stars)
    schedule_refresh()
    {:noreply, %{stars: stars}}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  defp fetch_stars(fallback \\ @fallback_stars) do
    case Req.get("https://api.github.com/repos/#{@repo}",
           headers: [{"accept", "application/vnd.github.v3+json"}],
           receive_timeout: 5_000
         ) do
      {:ok, %{status: 200, body: body}} ->
        body["stargazers_count"] || fallback

      _ ->
        fallback
    end
  end
end
