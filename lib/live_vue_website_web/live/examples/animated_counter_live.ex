defmodule LiveVueWebsiteWeb.Examples.AnimatedCounterLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("AnimatedCounter")
  @elixir_source ExampleSource.elixir_source("AnimatedCounter")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Animated Counter – LiveVue Examples",
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
    <Layouts.examples current_example="animated-counter">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Animated Counter</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Animated Counter
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Combine server state updates with smooth Vue transitions and animations.
          Watch the count animate when it changes from the server.
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
              <div class="font-medium text-landing-text text-sm">Vue Transitions</div>
              <div class="text-xs text-landing-muted">&lt;Transition&gt; component</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">watch() API</div>
              <div class="text-xs text-landing-muted">Reactive prop changes</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">CSS Animations</div>
              <div class="text-xs text-landing-muted">Custom @keyframes</div>
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
                {live_render(@socket, LiveVueWebsiteWeb.Examples.AnimatedCounterPreview,
                  id: "animated-counter-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="animated_counter_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="AnimatedCounter.vue"
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
              Watching for prop changes
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Vue's <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">watch()</code>
              API reacts to the server-driven
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">count</code>
              prop changing. When the LiveView updates the count, the watcher triggers the animation.
            </p>
            <.example_snippet
              language="javascript"
              code={~s|watch(() => props.count, (newVal, oldVal) => {
                  // Animate from oldVal to newVal
                })|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              Smooth number transitions
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Instead of jumping instantly, the displayed count interpolates from the old value to the new value over a fixed duration. This creates a smooth counting animation.
            </p>
            <.example_snippet
              language="javascript"
              code={~s|const displayCount = ref(props.count)
                // Interpolate displayCount from oldVal to newVal|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              CSS transition classes
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Vue's <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">&lt;Transition&gt;</code>
              component applies CSS classes during enter/leave phases. Combined with custom <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">@keyframes</code>, this creates the bounce effect.
            </p>
            <.example_snippet
              language="vue"
              code={~s|<Transition name="bounce" mode="out-in">
                  <div :key="displayCount">{{ displayCount }}</div>
                </Transition>|}
            />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: Connection Status with useLiveConnection()
          </div>
          <span class="text-landing-muted/50 text-sm">Coming soon</span>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
