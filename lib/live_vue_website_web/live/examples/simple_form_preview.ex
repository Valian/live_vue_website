defmodule LiveVueWebsiteWeb.Examples.SimpleFormPreview do
  @moduledoc """
  Minimal form demo LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  import Ecto.Changeset

  @types %{name: :string, email: :string, message: :string}

  def render(assigns) do
    ~H"""
    <.vue
      form={@form}
      v-component="examples/SimpleForm"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    changeset = changeset(%{})
    {:ok, assign(socket, form: to_form(changeset, as: :contact)), layout: false}
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
      # In a real app, you'd save the data here
      {:noreply,
       socket
       |> put_flash(:info, "Form submitted successfully!")
       |> assign(form: to_form(changeset(%{}), as: :contact))}
    else
      {:noreply, assign(socket, form: to_form(changeset, as: :contact))}
    end
  end

  defp changeset(params) do
    {%{}, @types}
    |> cast(params, Map.keys(@types))
    |> validate_required([:name, :email, :message])
    |> validate_length(:name, min: 2, max: 50)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
    |> validate_length(:message, min: 10, max: 500)
  end
end
