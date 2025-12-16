defmodule LiveVueWebsiteWeb.Examples.FileUploadPreview do
  @moduledoc """
  Minimal file upload LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <.vue
      upload={@uploads.document}
      uploadedFile={@uploaded_file}
      v-component="examples/FileUpload"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_file, nil)
     |> allow_upload(:document,
       accept: ~w(.pdf .txt .png .jpg .jpeg),
       max_entries: 1,
       max_file_size: 5_000_000,
       auto_upload: true
     ), layout: false}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :document, ref)}
  end

  def handle_event("save", _params, socket) do
    [file_stats] =
      consume_uploaded_entries(socket, :document, fn %{path: _path}, entry ->
        {:ok,
         %{
           name: entry.client_name,
           size: entry.client_size,
           type: entry.client_type
         }}
      end)

    {:noreply, assign(socket, :uploaded_file, file_stats)}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, assign(socket, :uploaded_file, nil)}
  end
end
