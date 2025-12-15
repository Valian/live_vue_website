defmodule LiveVueWebsiteWeb.Examples.EncoderPreview do
  @moduledoc """
  Demonstrates LiveVue.Encoder for custom structs.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  # Simple struct with derived encoder - all fields encoded
  defmodule Business do
    @derive LiveVue.Encoder
    defstruct [:name, :industry]
  end

  # Custom encoder with options support
  defmodule UserProfile do
    defstruct [:name, :email, :avatar_url, :avatar_original_url, :business]
  end

  defimpl LiveVue.Encoder, for: UserProfile do
    def encode(profile, opts) do
      avatar_url =
        case Keyword.get(opts, :avatar) do
          :original -> profile.avatar_original_url
          _ -> profile.avatar_url
        end

      %{
        name: profile.name,
        email: profile.email,
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
      profile_with_original_avatar={LiveVue.Encoder.encode(@profile, avatar: :original)}
      v-component="examples/Encoder"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    profile = %UserProfile{
      name: "Ada Lovelace",
      email: "ada@example.com",
      avatar_url: "https://api.dicebear.com/9.x/personas/svg?seed=Ada&size=64",
      avatar_original_url: "https://api.dicebear.com/9.x/personas/svg?seed=Ada&size=256",
      business: %Business{
        name: "Analytical Engine Co.",
        industry: "Computing"
      }
    }

    {:ok, assign(socket, profile: profile), layout: false}
  end
end
