defmodule LiveVueWebsiteWeb.Examples.SsrControlLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("SsrControl")
  @elixir_source ExampleSource.elixir_source("SsrControl")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "SSR Control – LiveVue Examples",
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
    <Layouts.examples current_example="ssr-control">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">SSR Control</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          SSR Control
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Control server-side rendering for components that need browser-only APIs.
          Use <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">v-ssr={false}</code>
          to disable SSR when needed.
        </p>
      </header>

      <%!-- Key concepts --%>
      <section class="mb-8 p-6 bg-landing-card/50 border border-landing-border rounded-xl">
        <h2 class="text-sm font-medium uppercase tracking-wider text-landing-muted mb-4">
          What this example shows
        </h2>
        <div class="grid grid-cols-3 gap-4 max-sm:grid-cols-1">
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              1
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">SSR by default</div>
              <div class="text-xs text-landing-muted">Components render on server</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">v-ssr={false}</div>
              <div class="text-xs text-landing-muted">Client-only rendering</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Browser APIs</div>
              <div class="text-xs text-landing-muted">window, navigator, etc.</div>
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
              <div class="w-full max-w-2xl">
                {live_render(@socket, LiveVueWebsiteWeb.Examples.SsrControlPreview,
                  id: "ssr-control-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="ssr_control_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="SsrControl.vue"
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
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                1
              </span>
              SSR enabled by default
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              LiveVue components are server-side rendered by default for faster initial page loads.
              The component renders to HTML on the server, then Vue hydrates it on the client.
            </p>
            <.example_snippet code={~s|<.vue v-component="SsrControl" v-socket={@socket} />|} />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              Disable SSR when needed
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Add <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">v-ssr={false}</code>
              to skip server rendering. The component shows a placeholder during SSR and only
              renders on the client after hydration.
            </p>
            <.example_snippet code={
              ~s|<.vue v-component="SsrControl" v-socket={@socket} v-ssr={false} />|
            } />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              Browser APIs require special handling
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              When using browser-only APIs like <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">window</code>, <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">navigator</code>, or <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">document</code>,
              you can either check if they exist or disable SSR entirely.
            </p>
            <.example_snippet
              language="javascript"
              code={~s|const userAgent =\n  typeof window !== 'undefined'\n    ? navigator.userAgent\n    : 'SSR'|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                4
              </span>
              When to use v-ssr={false}
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed">
              Use <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">v-ssr={false}</code>
              for components that heavily rely on browser APIs, third-party libraries that
              aren't SSR-compatible, or when the component doesn't benefit from SSR
              (like maps, charts, or client-only visualizations).
            </p>
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: Slots for composable components
          </div>
          <.link navigate="/examples/slots" class="text-vue hover:underline text-sm">
            View example →
          </.link>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
