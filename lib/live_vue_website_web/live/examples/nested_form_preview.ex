defmodule LiveVueWebsiteWeb.Examples.NestedFormPreview do
  @moduledoc """
  Minimal nested form demo LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  import Ecto.Changeset

  defmodule Address do
    use Ecto.Schema
    import Ecto.Changeset

    @derive LiveVue.Encoder
    @primary_key false
    embedded_schema do
      field :street, :string
      field :city, :string
      field :zip, :string
    end

    def changeset(address, attrs) do
      address
      |> cast(attrs, [:street, :city, :zip])
      |> validate_required([:street, :city, :zip])
      |> validate_length(:street, min: 3, max: 100)
      |> validate_length(:city, min: 2, max: 50)
      |> validate_format(:zip, ~r/^\d{5}$/, message: "must be 5 digits")
    end
  end

  defmodule Profile do
    use Ecto.Schema
    import Ecto.Changeset

    @derive LiveVue.Encoder
    @primary_key false
    embedded_schema do
      field :name, :string
      field :email, :string
      embeds_one :address, Address, on_replace: :update
    end

    def changeset(profile, attrs) do
      profile
      |> cast(attrs, [:name, :email])
      |> validate_required([:name, :email])
      |> validate_length(:name, min: 2, max: 50)
      |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
      |> cast_embed(:address, with: &Address.changeset/2)
    end
  end

  def render(assigns) do
    ~H"""
    <.vue
      form={@form}
      submitted={@submitted}
      v-component="examples/NestedForm"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    profile = %Profile{address: %Address{}}
    changeset = Profile.changeset(profile, %{})
    {:ok, assign(socket, form: to_form(changeset, as: :profile), submitted: nil), layout: false}
  end

  def handle_event("validate", %{"profile" => params}, socket) do
    profile = %Profile{address: %Address{}}

    changeset =
      profile
      |> Profile.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, as: :profile))}
  end

  def handle_event("submit", %{"profile" => params}, socket) do
    profile = %Profile{address: %Address{}}

    changeset =
      profile
      |> Profile.changeset(params)
      |> Map.put(:action, :insert)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      {:reply, %{reset: true},
       socket
       |> assign(submitted: data)
       |> assign(
         form: to_form(Profile.changeset(%Profile{address: %Address{}}, %{}), as: :profile)
       )}
    else
      {:noreply, assign(socket, form: to_form(changeset, as: :profile))}
    end
  end
end
