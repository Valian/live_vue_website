defmodule LiveVueWebsiteWeb.Examples.EventsLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("Events")
  @elixir_source ExampleSource.elixir_source("Events")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Event Handling – LiveVue Examples",
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
    <Layouts.examples current_example="events">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Event Handling</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Event Handling
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Two ways to send events from Vue to LiveView: Phoenix bindings like
          <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">phx-click</code>
          and programmatic <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">pushEvent()</code>
          via the <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveVue()</code>
          hook.
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
              <div class="font-medium text-landing-text text-sm">phx-click</div>
              <div class="text-xs text-landing-muted">Phoenix bindings in Vue</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">pushEvent()</div>
              <div class="text-xs text-landing-muted">Programmatic events</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">useLiveVue()</div>
              <div class="text-xs text-landing-muted">Access Phoenix hook</div>
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
                {live_render(@socket, LiveVueWebsiteWeb.Examples.EventsPreview, id: "events-preview")}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="events_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="Events.vue"
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
              Phoenix bindings work directly in Vue
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Standard Phoenix event bindings like
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">phx-click</code>
              work in Vue templates. Pass data with
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">phx-value-*</code>
              attributes.
            </p>
            <.example_snippet
              language="vue"
              code={~s|<button phx-click="phx_click_message" phx-value-text="Hello!">|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              useLiveVue() provides the Phoenix hook
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveVue()</code>
              composable returns the Phoenix LiveView hook instance.
              Use it for programmatic event handling.
            </p>
            <.example_snippet
              language="javascript"
              code="const live = useLiveVue()"
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              pushEvent() sends data to LiveView
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Call
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">pushEvent(name, payload)</code>
              to send events programmatically. This is useful when you need to send
              computed values or handle complex interactions.
            </p>
            <.example_snippet
              language="javascript"
              code={~s|live.pushEvent("add_message", { text: inputText.value })|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                4
              </span>
              handle_event receives both event types
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              LiveView handles events from both
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">phx-click</code>
              and <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">pushEvent()</code>
              the same way. The params contain the payload you sent.
            </p>
            <.example_snippet code={~s|def handle_event("add_message", %{"text" => text}, socket)|} />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: Server Events with useLiveEvent()
          </div>
          <.link navigate="/examples/server-events" class="text-vue hover:underline text-sm">
            View example →
          </.link>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
