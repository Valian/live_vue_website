defmodule LiveVueWebsiteWeb.Examples.ConnectionStatusLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("ConnectionStatus")
  @elixir_source ExampleSource.elixir_source("ConnectionStatus")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Connection Status – LiveVue Examples",
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
    <Layouts.examples current_example="connection-status">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Connection Status</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Connection Status
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Monitor the WebSocket connection state in real-time using the useLiveConnection() hook.
          Track when the connection is open, connecting, closing, or closed.
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
              <div class="font-medium text-landing-text text-sm">useLiveConnection()</div>
              <div class="text-xs text-landing-muted">Hook for connection state</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">WebSocket State</div>
              <div class="text-xs text-landing-muted">Reactive connection status</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Real-time Feedback</div>
              <div class="text-xs text-landing-muted">Visual connection indicator</div>
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
                {live_render(@socket, LiveVueWebsiteWeb.Examples.ConnectionStatusPreview,
                  id: "connection-status-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="connection_status_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="ConnectionStatus.vue"
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
              The useLiveConnection() hook
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveConnection()</code>
              hook provides reactive access to the WebSocket connection state. It returns
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">connectionState</code>
              (a ref with values "connecting", "open", "closing", or "closed") and
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">isConnected</code>
              (a computed boolean for convenience).
            </p>
            <.example_snippet
              language="javascript"
              code="const { connectionState, isConnected } = useLiveConnection()"
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              Reactive state tracking
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use Vue's <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">watch()</code>
              to track state changes over time. This example maintains a history of the last 5 state transitions
              with timestamps, demonstrating how connection state changes propagate through your component.
            </p>
            <.example_snippet
              language="javascript"
              code={
                ~s|watch(connectionState, (newState) => {\n  stateHistory.value.push({ state: newState, timestamp: new Date() })\n}, { immediate: true })|
              }
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              Visual feedback
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Bind the connection state to your UI with dynamic classes and animations. Show users when they're
              connected with a pulsing green indicator, or warn them about connection issues with red/amber states.
              This creates a responsive, transparent user experience.
            </p>
            <.example_snippet
              language="vue"
              code={~s|<span :class="isConnected ? 'bg-green-500 animate-pulse' : 'bg-red-500'" />|}
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
