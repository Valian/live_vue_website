defmodule LiveVueWebsiteWeb.Examples.CounterLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("Counter")
  @elixir_source ExampleSource.elixir_source("Counter")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Counter – LiveVue Examples",
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
    <Layouts.examples current_example="counter">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Counter</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Counter
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          The classic counter example demonstrating the core LiveVue pattern:
          server state flows down as props, user interactions bubble up as events.
        </p>
      </header>

      <%!-- Key concepts --%>
      <section class="mb-8 p-6 bg-landing-card/50 border border-landing-border rounded-xl">
        <h2 class="text-sm font-medium uppercase tracking-wider text-landing-muted mb-4">
          What this example shows
        </h2>
        <div class="grid grid-cols-4 gap-4 max-sm:grid-cols-1 max-md:grid-cols-2">
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              1
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Server State</div>
              <div class="text-xs text-landing-muted">count lives in LiveView</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Local State</div>
              <div class="text-xs text-landing-muted">diff slider is Vue-only</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Phoenix Events</div>
              <div class="text-xs text-landing-muted">phx-click in Vue template</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              4
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Vue Transitions</div>
              <div class="text-xs text-landing-muted">&lt;Transition&gt; on prop changes</div>
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
              <div class="w-full max-w-sm">
                {live_render(@socket, LiveVueWebsiteWeb.Examples.CounterPreview,
                  id: "counter-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="counter_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="Counter.vue"
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
              Props flow from LiveView to Vue
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">count</code>
              assign in LiveView
              becomes a prop in Vue. When the server state changes, Vue automatically re-renders with the new value.
            </p>
            <.example_snippet code={
              ~s|<.vue count={@count} v-component="Counter" v-socket={@socket} />|
            } />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              Local state stays in Vue
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">diff</code>
              slider value is managed entirely in Vue
              using <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">ref()</code>. No server round-trip for UI-only state.
            </p>
            <.example_snippet language="javascript" code="const diff = ref(1)  // Local Vue state" />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                3
              </span>
              Phoenix bindings work in Vue templates
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Standard Phoenix event bindings like
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">phx-click</code>
              work directly in Vue templates. Use Vue's
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">:phx-value-*</code>
              binding
              to pass dynamic values.
            </p>
            <.example_snippet
              language="vue"
              code={~s|<button phx-click="inc" :phx-value-diff="diff">+{{ diff }}</button>|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                4
              </span>
              Vue transitions on server updates
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Vue's <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">&lt;Transition&gt;</code>
              component animates when props change from the server. The
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">:key</code>
              binding triggers the transition on each value change.
            </p>
            <.example_snippet
              language="vue"
              code={~s|<Transition name="count" mode="out-in">
    <div :key="props.count">{{ props.count }}</div>
    </Transition>|}
            />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: Event Handling
          </div>
          <.link navigate="/examples/events" class="text-vue hover:underline text-sm">
            View example →
          </.link>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
