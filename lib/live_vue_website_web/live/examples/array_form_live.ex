defmodule LiveVueWebsiteWeb.Examples.ArrayFormLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("ArrayForm")
  @elixir_source ExampleSource.elixir_source("ArrayForm")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Dynamic Arrays – LiveVue Examples",
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
    <Layouts.examples current_example="array-form">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Dynamic Arrays</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Dynamic Arrays
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Use <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">fieldArray()</code>
          to manage dynamic lists with add, remove, and per-item validation.
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
              <div class="font-medium text-landing-text text-sm">fieldArray()</div>
              <div class="text-xs text-landing-muted">form.fieldArray("tags")</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Add & Remove</div>
              <div class="text-xs text-landing-muted">tagsArray.add(), .remove(i)</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Per-Item Errors</div>
              <div class="text-xs text-landing-muted">tags[0], tags[1] validation</div>
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
                {live_render(@socket, LiveVueWebsiteWeb.Examples.ArrayFormPreview,
                  id: "array-form-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="array_form_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="ArrayForm.vue"
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
              Define an embedded schema or relation
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">embeds_many</code>
              or <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">has_many</code>
              to define array items. Each item gets its own changeset and validation.
            </p>
            <.example_snippet code="defmodule Tag do\n  use Ecto.Schema\n  @derive LiveVue.Encoder\n  embedded_schema do\n    field :name, :string\n  end\nend\n\nembeds_many :tags, Tag, on_replace: :delete" />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              Get an array field reference
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">form.fieldArray("tags")</code>
              to get a reactive array with add, remove, and iteration capabilities. Nested access is supported.
            </p>
            <.example_snippet
              language="javascript"
              code={"const tagsArray = form.fieldArray(\"tags\")\n\n// Add a new tag object\ntagsArray.add({ name: '' })\n\n// Remove tag at index\ntagsArray.remove(index)"}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              Iterate and access nested fields
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Loop over
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">tagsArray.fields.value</code>
              and use
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">tagField.field('name')</code>
              to access each item's properties with full error support.
            </p>
            <.example_snippet
              language="vue"
              code={"<div v-for=\"(tagField, index) in tagsArray.fields.value\" :key=\"index\">\n  <input v-bind=\"tagField.field('name').inputAttrs.value\" />\n  <div v-if=\"tagField.field('name').errorMessage.value\">\n    {{ tagField.field('name').errorMessage.value }}\n  </div>\n  <button @click=\"tagsArray.remove(index)\">Remove</button>\n</div>"}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                4
              </span>
              Use cast_embed for validation
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Call
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">cast_embed(:tags)</code>
              to automatically validate each item using its own changeset. Errors are mapped per-item.
            </p>
            <.example_snippet code="def changeset(post, attrs) do\n  post\n  |> cast(attrs, [:title])\n  |> validate_required([:title])\n  |> cast_embed(:tags, with: &Tag.changeset/2)\nend" />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: File uploads with useLiveUpload()
          </div>
          <.link navigate="/examples/file-upload" class="text-vue hover:underline text-sm">
            View example →
          </.link>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
