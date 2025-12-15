defmodule LiveVueWebsiteWeb.Examples.SimpleFormLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("SimpleForm")
  @elixir_source ExampleSource.elixir_source("SimpleForm")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Simple Form – LiveVue Examples",
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
    <Layouts.examples current_example="simple-form">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Simple Form</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Simple Form
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Build forms with <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveForm()</code>
          that sync with Ecto changesets. Server-side validation with real-time feedback,
          all powered by Phoenix LiveView.
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
              <div class="font-medium text-landing-text text-sm">useLiveForm()</div>
              <div class="text-xs text-landing-muted">Form state management</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Ecto Changeset</div>
              <div class="text-xs text-landing-muted">Server-side validation</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Debounced Events</div>
              <div class="text-xs text-landing-muted">Efficient validation</div>
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
                {live_render(@socket, LiveVueWebsiteWeb.Examples.SimpleFormPreview,
                  id: "simple-form-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="simple_form_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="SimpleForm.vue"
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
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                1
              </span>
              Initialize the form with useLiveForm()
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveForm()</code>
              composable takes the form prop and configuration. It returns reactive form state
              and field accessors.
            </p>
            <.example_snippet
              language="javascript"
              code={"const form = useLiveForm(() => props.form, {\n  changeEvent: \"validate\",\n  submitEvent: \"submit\",\n  debounceInMiliseconds: 300\n})"}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              Access fields with form.field()
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Each field provides reactive state including <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">value</code>, <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">errorMessage</code>, <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">isTouched</code>,
              and <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">inputAttrs</code>
              for binding.
            </p>
            <.example_snippet
              language="javascript"
              code={"const nameField = form.field(\"name\")\n// Use: nameField.inputAttrs.value, nameField.errorMessage.value"}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                3
              </span>
              Server validates with Ecto changeset
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The LiveView uses
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">Ecto.Changeset</code>
              for validation. Use
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">to_form()</code>
              to convert the changeset to a form that LiveVue understands.
            </p>
            <.example_snippet code={
              String.trim(
                "changeset = changeset(params) |> Map.put(:action, :validate)\nassign(socket, form: to_form(changeset, as: :contact))"
              )
            } />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                4
              </span>
              Bind inputs with v-bind and inputAttrs
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">v-bind</code>
              with <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">inputAttrs.value</code>
              to automatically wire up value, name, id, and event handlers.
            </p>
            <.example_snippet
              language="vue"
              code={~s|<input v-bind="nameField.inputAttrs.value" type="text" />|}
            />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <.link
          navigate="/examples/nested-form"
          class="flex items-center justify-between group"
        >
          <div class="text-landing-muted text-sm group-hover:text-landing-text transition-colors">
            Next up: Nested Objects with dot notation paths
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
