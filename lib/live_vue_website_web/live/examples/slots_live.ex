defmodule LiveVueWebsiteWeb.Examples.SlotsLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("Slots")
  @elixir_source ExampleSource.elixir_source("Slots")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Slots – LiveVue Examples",
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
    <Layouts.examples current_example="slots">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Slots</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Slots
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Pass HEEx content into Vue components using slots. Combine the power of server-rendered
          templates with Vue's component composition.
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
              <div class="font-medium text-landing-text text-sm">Default Slot</div>
              <div class="text-xs text-landing-muted">Main content between tags</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Named Slots</div>
              <div class="text-xs text-landing-muted">Header, footer, icon slots</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Fallback Content</div>
              <div class="text-xs text-landing-muted">Default content when slot empty</div>
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
            <div class="p-8">
              <div class="max-w-2xl mx-auto">
                {live_render(@socket, LiveVueWebsiteWeb.Examples.SlotsPreview, id: "slots-preview")}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="slots_preview.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="Slots.vue"
              color="vue"
            />
        <% end %>
      </div>

      <%!-- Explanation --%>
      <section class="mt-8 space-y-6">
        <h2 class="font-serif text-2xl tracking-tight">How it works</h2>

        <div class="grid gap-4">
          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                1
              </span>
              Vue components define slot insertion points
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              In the Vue component, use
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">&lt;slot /&gt;</code>
              for the default slot and
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">
                &lt;slot name="header" /&gt;
              </code>
              for named slots. These act as placeholders for content passed from HEEx.
            </p>
            <.example_snippet
              language="vue"
              code={~s|<slot />  <!-- default slot -->\n<slot name="header" />  <!-- named slot -->|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                2
              </span>
              HEEx uses :slot_name syntax to pass content
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              In LiveView templates, content placed directly between the
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">&lt;.vue&gt;</code>
              tags becomes the default slot. Named slots use the
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">:slot_name</code>
              syntax.
            </p>
            <.example_snippet
              language="elixir"
              code={
                ~s|<.vue v-component="Card" v-socket={@socket}>\n  <:header>Title</:header>\n  Default slot content\n</.vue>|
              }
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              Slots can have fallback content
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              When a slot isn't provided, Vue renders the fallback content inside the
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">&lt;slot&gt;</code>
              tags. This is useful for optional sections or default states.
            </p>
            <.example_snippet
              language="vue"
              code={~s|<slot name="footer">\n  <p>Default footer content</p>\n</slot>|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                4
              </span>
              Check slot presence in Vue
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useSlots()</code>
              to conditionally render sections based on whether a slot was provided. This enables
              flexible layouts that adapt to the content.
            </p>
            <.example_snippet
              language="javascript"
              code={~s|const slots = useSlots()\nconst hasFooter = computed(() => !!slots.footer)|}
            />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: Simple Form with useLiveForm()
          </div>
          <.link navigate="/examples/simple-form" class="text-vue hover:underline text-sm">
            View example →
          </.link>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
