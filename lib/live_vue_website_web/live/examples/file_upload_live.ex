defmodule LiveVueWebsiteWeb.Examples.FileUploadLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("FileUpload")
  @elixir_source ExampleSource.elixir_source("FileUpload")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "File Upload – LiveVue Examples",
       vue_source: @vue_source,
       elixir_source: @elixir_source
     )}
  end

  def handle_params(params, _uri, socket) do
    tab = if params["tab"] in @valid_tabs, do: params["tab"], else: "preview"
    {:noreply, assign(socket, :active_tab, tab)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.examples current_example="file-upload">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">File Upload</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          File Upload
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Upload files with
          <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveUpload()</code>
          powered by Phoenix LiveView's built-in upload handling. Includes drag-and-drop,
          progress tracking, and server-side processing.
        </p>
      </header>

      <%!-- Key concepts --%>
      <section class="mb-8 p-6 bg-landing-card/50 border border-landing-border rounded-xl">
        <h2 class="text-sm font-medium uppercase tracking-wider text-landing-muted mb-4">
          What this example shows
        </h2>
        <div class="grid grid-cols-3 gap-4 max-sm:grid-cols-1">
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              1
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">useLiveUpload()</div>
              <div class="text-xs text-landing-muted">Upload state and progress</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">allow_upload/3</div>
              <div class="text-xs text-landing-muted">Server-side config</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Drag & Drop</div>
              <div class="text-xs text-landing-muted">addFiles() helper</div>
            </div>
          </div>
        </div>
      </section>

      <%!-- Tabs --%>
      <div class="mb-6">
        <div class="flex gap-1 p-1 bg-landing-elevated rounded-lg w-fit">
          <.link
            patch="?tab=preview"
            class={[
              "py-2 px-4 rounded-md text-sm font-medium transition-all",
              if(@active_tab == "preview",
                do: "bg-landing-card text-landing-text shadow-sm",
                else: "text-landing-muted hover:text-landing-text"
              )
            ]}
          >
            Preview
          </.link>
          <.link
            patch="?tab=liveview"
            class={[
              "py-2 px-4 rounded-md text-sm font-medium transition-all",
              if(@active_tab == "liveview",
                do: "bg-landing-card text-landing-text shadow-sm",
                else: "text-landing-muted hover:text-landing-text"
              )
            ]}
          >
            <span class="flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-phoenix"></span> LiveView
            </span>
          </.link>
          <.link
            patch="?tab=vue"
            class={[
              "py-2 px-4 rounded-md text-sm font-medium transition-all",
              if(@active_tab == "vue",
                do: "bg-landing-card text-landing-text shadow-sm",
                else: "text-landing-muted hover:text-landing-text"
              )
            ]}
          >
            <span class="flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-vue"></span> Vue
            </span>
          </.link>
        </div>
      </div>

      <%!-- Tab Content --%>
      <div class="bg-landing-card border border-landing-border rounded-xl overflow-hidden">
        <%= case @active_tab do %>
          <% "preview" -> %>
            <div class="p-8 flex justify-center">
              <div class="w-full max-w-md">
                {live_render(@socket, LiveVueWebsiteWeb.Examples.FileUploadPreview,
                  id: "file-upload-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="file_upload_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="FileUpload.vue"
              color="vue"
            />
        <% end %>
      </div>

      <%!-- Explanation --%>
      <section class="mt-8 space-y-6">
        <h2 class="font-serif text-2xl tracking-tight">How it works</h2>

        <div class="grid gap-4">
          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                1
              </span>
              Configure uploads with allow_upload/3
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              In the LiveView mount, use
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">allow_upload/3</code>
              to configure accepted file types, limits, and auto-upload behavior.
            </p>
            <.example_snippet code="allow_upload(:document,\n  accept: ~w(.pdf .txt .png .jpg .jpeg),\n  max_entries: 1,\n  max_file_size: 5_000_000,\n  auto_upload: true\n)" />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              Initialize with useLiveUpload()
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Pass the upload config from props and specify event names.
              The hook returns reactive state and helper functions.
            </p>
            <.example_snippet
              language="javascript"
              code={"const {\n  entries,\n  showFilePicker,\n  addFiles,\n  progress,\n  cancel,\n  valid\n} = useLiveUpload(() => props.upload, {\n  changeEvent: \"validate\",\n  submitEvent: \"save\"\n})"}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              Handle drag and drop
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">addFiles()</code>
              with the DataTransfer object from drop events.
            </p>
            <.example_snippet
              language="vue"
              code={"<div\n  @drop.prevent=\"addFiles($event.dataTransfer)\"\n  @dragover.prevent\n  @click=\"showFilePicker\"\n>\n  <!-- Drop zone content -->\n</div>"}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                4
              </span>
              Track upload progress
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Each entry in <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">entries</code>
              has <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">progress</code>
              (0-100), <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">client_name</code>, <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">client_size</code>, and <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">errors</code>.
            </p>
            <.example_snippet
              language="vue"
              code={"<div v-for=\"entry in entries\" :key=\"entry.ref\">\n  {{ entry.client_name }} - {{ entry.progress }}%\n  <button @click=\"cancel(entry.ref)\">Cancel</button>\n</div>"}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                5
              </span>
              Process uploads on the server
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">
                consume_uploaded_entries/3
              </code>
              to process files. The callback receives the temporary file path and entry metadata.
            </p>
            <.example_snippet code="consume_uploaded_entries(socket, :document, fn %{path: path}, entry ->\n  # Process file: copy, analyze, store, etc.\n  {:ok, %{name: entry.client_name, size: entry.client_size}}\nend)" />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <.link
          navigate="/examples/streams"
          class="flex items-center justify-between group"
        >
          <div class="text-landing-muted text-sm group-hover:text-landing-text transition-colors">
            Next up: Phoenix Streams for efficient list updates
          </div>
          <span class="text-vue text-sm flex items-center gap-1 group-hover:gap-2 transition-all">
            View example
            <svg
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              class="w-4 h-4"
            >
              <path d="M9 18l6-6-6-6" />
            </svg>
          </span>
        </.link>
      </section>
    </Layouts.examples>
    """
  end
end
