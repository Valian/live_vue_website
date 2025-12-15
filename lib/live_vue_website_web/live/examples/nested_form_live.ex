defmodule LiveVueWebsiteWeb.Examples.NestedFormLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("NestedForm")
  @elixir_source ExampleSource.elixir_source("NestedForm")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Nested Objects – LiveVue Examples",
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
    <Layouts.examples current_example="nested-form">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Nested Objects</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Nested Objects
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Access nested form fields using
          <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">dot notation</code>
          paths. Perfect for forms with embedded objects like addresses, profiles, or settings.
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
              <div class="font-medium text-landing-text text-sm">Dot Notation</div>
              <div class="text-xs text-landing-muted">form.field("address.city")</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Nested Validation</div>
              <div class="text-xs text-landing-muted">Errors per nested field</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Flat Params</div>
              <div class="text-xs text-landing-muted">Nested data sent as nested map</div>
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
                {live_render(@socket, LiveVueWebsiteWeb.Examples.NestedFormPreview,
                  id: "nested-form-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="nested_form_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="NestedForm.vue"
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
              Use <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">embeds_one</code>
              or <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">has_one</code>/<code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">belongs_to</code> to define nested objects. Each gets its own changeset and validation.
            </p>
            <.example_snippet code="defmodule Address do\n  use Ecto.Schema\n  @derive LiveVue.Encoder\n  embedded_schema do\n    field :street, :string\n    field :city, :string\n    field :zip, :string\n  end\nend\n\nembeds_one :address, Address, on_replace: :update" />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                2
              </span>
              Use cast_embed for validation
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Call
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">
                cast_embed(:address)
              </code>
              to automatically validate nested fields. Errors are mapped to the correct nested paths.
            </p>
            <.example_snippet code="def changeset(profile, attrs) do\n  profile\n  |> cast(attrs, [:name, :email])\n  |> validate_required([:name, :email])\n  |> cast_embed(:address, with: &Address.changeset/2)\nend" />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              Access nested fields with dot notation or chaining
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">form.field("address.city")</code>
              or chain with <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">.field()</code>.
              Both have full TypeScript support for type-safe paths. Use `field[index]` to access nested array fields, eg `form.field("tags[0].name")`.
            </p>
            <.example_snippet
              language="javascript"
              code={"// Dot notation\nconst cityField = form.field(\"address.city\")\n\n// Or chain .field() calls\nconst addressField = form.field(\"address\")\nconst cityField = addressField.field(\"city\")"}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                4
              </span>
              Bind inputs exactly like flat fields
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Once you have a field reference, use it exactly like any other field.
              The <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">inputAttrs</code>, <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">errorMessage</code>, and
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">isTouched</code>
              work identically.
            </p>
            <.example_snippet
              language="vue"
              code={"<input v-bind=\"cityField.inputAttrs.value\" type=\"text\" />\n<div v-if=\"cityField.errorMessage.value\">\n  {{ cityField.errorMessage.value }}\n</div>"}
            />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <.link
          navigate="/examples/array-form"
          class="flex items-center justify-between group hover:bg-landing-card/50 -mx-4 px-4 py-3 rounded-lg transition-colors"
        >
          <div class="text-landing-muted text-sm group-hover:text-landing-text transition-colors">
            Next up: Dynamic Arrays with fieldArray()
          </div>
          <svg
            viewBox="0 0 24 24"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            class="w-4 h-4 text-landing-muted group-hover:text-vue transition-colors"
          >
            <path d="M9 18l6-6-6-6" />
          </svg>
        </.link>
      </section>
    </Layouts.examples>
    """
  end
end
