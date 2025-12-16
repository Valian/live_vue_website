defmodule LiveVueWebsiteWeb.Examples.EncoderPreview do
  @moduledoc """
  Demonstrates LiveVue.Encoder for custom structs.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  defmodule Business do
    @derive LiveVue.Encoder
    defstruct [:name, :industry]
  end

  defmodule UserProfile do
    defstruct [:name, :avatar_url, :avatar_original_url, :business]
  end

  defimpl LiveVue.Encoder, for: UserProfile do
    def encode(profile, opts) do
      avatar_url =
        if Keyword.get(opts, :avatar) == :original,
          do: profile.avatar_original_url,
          else: profile.avatar_url

      %{
        name: profile.name,
        avatar_url: avatar_url,
        business: LiveVue.Encoder.encode(profile.business, opts)
      }
      |> LiveVue.Encoder.encode(opts)
    end
  end

  def render(assigns) do
    ~H"""
    <.vue
      profile={@profile}
      profile_original={LiveVue.Encoder.encode(@profile, avatar: :original)}
      v-component="examples/Encoder"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    profile = %UserProfile{
      name: "Ada Lovelace",
      avatar_url: "https://api.dicebear.com/9.x/personas/png?seed=Lovelace&size=32",
      avatar_original_url: "https://api.dicebear.com/9.x/personas/png?seed=Lovelace&size=256",
      business: %Business{name: "Analytical Engine Co.", industry: "Computing"}
    }

    {:ok, assign(socket, profile: profile), layout: false}
  end
end
