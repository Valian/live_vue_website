defmodule LiveVueWebsiteWeb.Examples.InjectLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("Inject")
  @layout_vue_source ExampleSource.vue_source("InjectLayout")
  @elixir_source ExampleSource.elixir_source("Inject")

  @valid_tabs ~w(preview liveview vue vue-layout)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "v-inject – LiveVue Examples",
       vue_source: @vue_source,
       layout_vue_source: @layout_vue_source,
       elixir_source: @elixir_source
     )}
  end

  def handle_params(params, _uri, socket) do
    tab = if params["tab"] in @valid_tabs, do: params["tab"], else: "preview"
    {:noreply, assign(socket, :active_tab, tab)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.examples current_example="inject">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">v-inject</span>
        </div>
        <div class="flex items-center gap-3 mb-4">
          <h1 class="font-serif text-4xl font-normal tracking-tight">
            v-inject
          </h1>
          <span class="inline-flex items-center py-0.5 px-2 bg-vue/10 border border-vue/30 rounded-full text-xs font-mono text-vue">
            v1.1
          </span>
        </div>
        <p class="text-lg text-landing-muted max-w-2xl">
          Inject a Vue component into another component's slot — even when they're rendered
          by different LiveViews. The layout component persists while only the page content changes.
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
              <div class="font-medium text-landing-text text-sm">Layout Component</div>
              <div class="text-xs text-landing-muted">Rendered with an id, owns the slot</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Slot Injection</div>
              <div class="text-xs text-landing-muted">v-inject targets the layout by id</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Independent Updates</div>
              <div class="text-xs text-landing-muted">Layout and page update separately</div>
            </div>
          </div>
        </div>
      </section>

      <%!-- Tabs --%>
      <div class="mb-6">
        <div class="flex gap-1 p-1 bg-landing-elevated rounded-lg w-fit flex-wrap">
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
              <span class="w-2 h-2 rounded-full bg-vue"></span> Page
            </span>
          </.link>
          <.link
            patch="?tab=vue-layout"
            class={[
              "py-2 px-4 rounded-md text-sm font-medium transition-all",
              if(@active_tab == "vue-layout",
                do: "bg-landing-card text-landing-text shadow-sm",
                else: "text-landing-muted hover:text-landing-text"
              )
            ]}
          >
            <span class="flex items-center gap-2">
              <span class="w-2 h-2 rounded-full bg-vue"></span> Layout
            </span>
          </.link>
        </div>
      </div>

      <%!-- Tab Content --%>
      <div class="bg-landing-card border border-landing-border rounded-xl overflow-hidden">
        <%= case @active_tab do %>
          <% "preview" -> %>
            <div class="p-8">
              <div class="max-w-md mx-auto">
                {live_render(@socket, LiveVueWebsiteWeb.Examples.InjectPreview, id: "inject-preview")}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="inject_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="Inject.vue"
              color="vue"
            />
          <% "vue-layout" -> %>
            <.example_code
              id="code-tab-vue-layout"
              code={@layout_vue_source}
              language="vue"
              filename="InjectLayout.vue"
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
              Render a layout component with an id
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The layout component is rendered with a unique <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">id</code>.
              It defines a
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">&lt;slot /&gt;</code>
              where page content will be injected.
              In a real app, this would typically live in
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">root.html.heex</code>
              or a sticky LiveView.
            </p>
            <.example_snippet code={
              ~s|<.vue id="app-layout" v-component="AppLayout" v-socket={@socket} title="My App" />|
            } />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                2
              </span>
              Inject a page into the layout's slot
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The page component uses
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">v-inject="app-layout"</code>
              to target the layout by its id. The page is rendered inside the layout's default slot
              instead of inline.
            </p>
            <.example_snippet code={
              ~s|<.vue v-component="Page" v-inject="app-layout" v-socket={@socket} message={@message} />|
            } />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                3
              </span>
              Layout and page update independently
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed">
              Toggle the theme — only the layout re-renders. Change the message — only the page
              updates. In a real app with a sticky LiveView layout, the layout Vue component persists
              across LiveView navigation while pages swap in and out of the slot.
            </p>
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: Headless Shared Props
          </div>
          <.link navigate="/examples/shared-props" class="text-vue hover:underline text-sm">
            View example →
          </.link>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
