defmodule LiveVueWebsiteWeb.Examples.ServerEventsLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("ServerEvents")
  @elixir_source ExampleSource.elixir_source("ServerEvents")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Server Events – LiveVue Examples",
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
    <Layouts.examples current_example="server-events">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Server Events</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Server Events
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Server-to-client communication using
          <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">push_event/3</code>
          on the server and
          <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveEvent()</code>
          on the client for real-time notifications and updates.
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
              <div class="font-medium text-landing-text text-sm">push_event</div>
              <div class="text-xs text-landing-muted">Server sends to client</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">useLiveEvent()</div>
              <div class="text-xs text-landing-muted">Client receives events</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Multiple Events</div>
              <div class="text-xs text-landing-muted">Different event types</div>
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
              <div class="w-full max-w-lg">
                {live_render(@socket, LiveVueWebsiteWeb.Examples.ServerEventsPreview,
                  id: "server-events-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="server_events_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="ServerEvents.vue"
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
              Server pushes events to client
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">push_event/3</code>
              in LiveView to send data to the client. The first argument is the socket,
              the second is the event name, and the third is the payload.
            </p>
            <.example_snippet code={~s|push_event(socket, "notification", %{message: "Hello!"})|}/>
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              useLiveEvent() listens for events
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveEvent()</code>
              composable registers a listener for server events. It automatically handles cleanup
              when the component unmounts.
            </p>
            <.example_snippet
              language="javascript"
              code={~s|useLiveEvent('notification', (data) => { /* handle event */ })|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              Multiple event types
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              You can use different event names for different types of server pushes.
              Each <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveEvent()</code>
              call can listen to a specific event type.
            </p>
            <.example_snippet
              language="javascript"
              code={~s|useLiveEvent('notification', handleNotification)\nuseLiveEvent('alert', handleAlert)|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                4
              </span>
              Triggered by any handle_event
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Server events can be pushed from any
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">handle_event/3</code>
              callback. This example triggers them from button clicks, but they could come from
              background processes, PubSub, or any other source.
            </p>
            <.example_snippet code={~s|def handle_event("trigger", _, socket) do\n  {:noreply, push_event(socket, "event_name", data)}\nend|}/>
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: Navigation with Link component
          </div>
          <.link navigate="/examples/navigation" class="text-phoenix hover:text-phoenix/80 text-sm font-medium">
            Navigation →
          </.link>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
