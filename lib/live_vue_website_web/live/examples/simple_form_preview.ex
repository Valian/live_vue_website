defmodule LiveVueWebsiteWeb.Examples.SimpleFormPreview do
  @moduledoc """
  Minimal form demo LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  import Ecto.Changeset

  @types %{name: :string, email: :string, consent: :boolean}

  def render(assigns) do
    ~H"""
    <.vue
      form={@form}
      submitted={@submitted}
      v-component="examples/SimpleForm"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    changeset = changeset(%{})
    {:ok, assign(socket, form: to_form(changeset, as: :contact), submitted: nil), layout: false}
  end

  def handle_event("validate", %{"contact" => params}, socket) do
    changeset =
      changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, as: :contact))}
  end

  def handle_event("submit", %{"contact" => params}, socket) do
    changeset =
      changeset(params)
      |> Map.put(:action, :insert)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      {:reply, %{reset: true},
       socket
       |> assign(submitted: data)
       |> assign(form: to_form(changeset(%{}), as: :contact))}
    else
      {:noreply, assign(socket, form: to_form(changeset, as: :contact))}
    end
  end

  defp changeset(params) do
    {%{}, @types}
    |> cast(params, Map.keys(@types))
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 2, max: 50)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> validate_acceptance(:consent, message: "you must consent to continue")
  end
end
