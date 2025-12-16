defmodule LiveVueWebsiteWeb.Examples.ArrayFormPreview do
  @moduledoc """
  Minimal dynamic array form demo LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  import Ecto.Changeset

  defmodule Tag do
    use Ecto.Schema
    import Ecto.Changeset

    @derive LiveVue.Encoder
    @primary_key false
    embedded_schema do
      field :name, :string
    end

    def changeset(tag, attrs) do
      tag
      |> cast(attrs, [:name], empty_values: [])
      |> validate_required([:name])
      |> validate_length(:name, min: 2, max: 30)
    end
  end

  defmodule Post do
    use Ecto.Schema
    import Ecto.Changeset

    @derive LiveVue.Encoder
    @primary_key false
    embedded_schema do
      field :title, :string
      embeds_many :tags, Tag, on_replace: :delete
    end

    def changeset(post, attrs) do
      post
      |> cast(attrs, [:title])
      |> validate_required([:title])
      |> validate_length(:title, min: 2, max: 100)
      |> cast_embed(:tags, with: &Tag.changeset/2)
    end
  end

  def render(assigns) do
    ~H"""
    <.vue
      form={@form}
      submitted={@submitted}
      v-component="examples/ArrayForm"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    changeset = Post.changeset(%Post{}, %{})
    {:ok, assign(socket, form: to_form(changeset, as: :post), submitted: nil), layout: false}
  end

  def handle_event("validate", %{"post" => params}, socket) do
    changeset =
      %Post{}
      |> Post.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset, as: :post))}
  end

  def handle_event("submit", %{"post" => params}, socket) do
    changeset =
      %Post{}
      |> Post.changeset(params)
      |> Map.put(:action, :insert)

    if changeset.valid? do
      data = Ecto.Changeset.apply_changes(changeset)

      {:reply, %{reset: true},
       socket
       |> assign(submitted: data)
       |> assign(form: to_form(Post.changeset(%Post{}, %{}), as: :post))}
    else
      {:noreply, assign(socket, form: to_form(changeset, as: :post))}
    end
  end
end
