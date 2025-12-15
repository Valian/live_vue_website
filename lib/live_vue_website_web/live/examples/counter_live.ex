defmodule LiveVueWebsiteWeb.Examples.CounterLive do
  use LiveVueWebsiteWeb, :live_view

  # Embed source files at compile time for display
  # @external_resource ensures recompilation when these files change
  @vue_path Path.join(File.cwd!(), "assets/vue/examples/Counter.vue")
  @external_resource @vue_path
  @vue_source File.read!(@vue_path)

  @elixir_source ~s'''
  defmodule MyAppWeb.CounterLive do
    use MyAppWeb, :live_view

    def render(assigns) do
      ~H"""
      <.vue
        count={@count}
        v-component="Counter"
        v-socket={@socket}
      />
      """
    end

    def mount(_params, _session, socket) do
      {:ok, assign(socket, count: 0)}
    end

    def handle_event("inc", %{"diff" => diff}, socket) do
      {:noreply, update(socket, :count, &(&1 + diff))}
    end

    def handle_event("dec", _params, socket) do
      {:noreply, update(socket, :count, &(&1 - 1))}
    end

    def handle_event("reset", _params, socket) do
      {:noreply, assign(socket, :count, 0)}
    end
  end
  '''

  @examples [
    %{
      category: "Getting Started",
      items: [
        %{id: "counter", title: "Counter", icon: "hero-plus-circle", active: true},
        %{id: "animated-counter", title: "Animated Counter", icon: "hero-sparkles", active: false}
      ]
    },
    %{
      category: "Events",
      items: [
        %{id: "events", title: "Event Handling", icon: "hero-cursor-arrow-rays", active: false},
        %{id: "server-events", title: "Server Events", icon: "hero-bell-alert", active: false}
      ]
    },
    %{
      category: "Navigation",
      items: [
        %{id: "navigation", title: "Navigation", icon: "hero-arrow-path", active: false}
      ]
    },
    %{
      category: "Forms",
      items: [
        %{id: "simple-form", title: "Simple Form", icon: "hero-document-text", active: false},
        %{
          id: "nested-form",
          title: "Nested Objects",
          icon: "hero-square-3-stack-3d",
          active: false
        },
        %{id: "array-form", title: "Dynamic Arrays", icon: "hero-queue-list", active: false}
      ]
    },
    %{
      category: "Uploads",
      items: [
        %{id: "file-upload", title: "File Upload", icon: "hero-cloud-arrow-up", active: false}
      ]
    },
    %{
      category: "Real-time",
      items: [
        %{id: "streams", title: "Phoenix Streams", icon: "hero-signal", active: false},
        %{id: "connection-status", title: "Connection Status", icon: "hero-wifi", active: false}
      ]
    },
    %{
      category: "Advanced",
      items: [
        %{id: "slots", title: "Slots", icon: "hero-puzzle-piece", active: false},
        %{id: "ssr-control", title: "SSR Control", icon: "hero-server", active: false}
      ]
    }
  ]

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Counter – LiveVue Examples",
       count: 0,
       active_tab: "preview",
       vue_source: @vue_source,
       elixir_source: @elixir_source,
       examples: @examples
     )}
  end

  def handle_event("inc", %{"diff" => diff}, socket) do
    {:noreply, update(socket, :count, &(&1 + diff))}
  end

  def handle_event("dec", _params, socket) do
    {:noreply, update(socket, :count, &(&1 - 1))}
  end

  def handle_event("reset", _params, socket) do
    {:noreply, assign(socket, :count, 0)}
  end

  def handle_event("set_tab", %{"tab" => tab}, socket) do
    {:noreply, assign(socket, :active_tab, tab)}
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-landing-deep text-landing-text font-[Inter,system-ui,sans-serif]">
      <%!-- Ambient background --%>
      <div class="fixed inset-0 overflow-hidden pointer-events-none">
        <div class="absolute rounded-full blur-[120px] opacity-20 w-[500px] h-[500px] bg-[radial-gradient(circle,var(--color-phoenix)_0%,transparent_70%)] -top-[200px] -right-[150px]">
        </div>
        <div class="absolute rounded-full blur-[120px] opacity-20 w-[400px] h-[400px] bg-[radial-gradient(circle,var(--color-vue)_0%,transparent_70%)] bottom-[10%] -left-[100px]">
        </div>
        <div class="absolute inset-0 bg-[linear-gradient(rgba(255,255,255,0.015)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.015)_1px,transparent_1px)] bg-[size:50px_50px] [mask-image:radial-gradient(ellipse_at_center,black_0%,transparent_80%)]">
        </div>
      </div>

      <div class="relative flex min-h-screen">
        <%!-- Side Navigation --%>
        <aside class="w-72 shrink-0 border-r border-landing-border/50 bg-landing-bg/50 backdrop-blur-sm">
          <div class="sticky top-0 h-screen overflow-y-auto py-6 px-4">
            <%!-- Logo/Back link --%>
            <a
              href="/"
              class="flex items-center gap-3 mb-8 px-3 py-2 -mx-1 rounded-lg transition-colors hover:bg-white/5 group"
            >
              <img
                src="/images/live_vue_logo_rounded.png"
                alt="LiveVue"
                class="h-8 w-8 rounded-md"
              />
              <span class="font-serif text-xl tracking-tight">
                <span class="text-phoenix">Live</span><span class="text-vue">Vue</span>
              </span>
              <svg
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                class="w-4 h-4 ml-auto text-landing-muted opacity-0 -translate-x-1 transition-all group-hover:opacity-100 group-hover:translate-x-0"
              >
                <path d="M19 12H5M12 19l-7-7 7-7" />
              </svg>
            </a>

            <%!-- Section title --%>
            <div class="px-3 mb-6">
              <a
                href="/examples"
                class="font-serif text-sm uppercase tracking-[0.2em] text-landing-muted hover:text-landing-text transition-colors"
              >
                Examples
              </a>
            </div>

            <%!-- Navigation items --%>
            <nav class="space-y-6">
              <%= for category <- @examples do %>
                <div>
                  <h3 class="px-3 mb-2 text-[11px] font-medium uppercase tracking-wider text-landing-muted/70">
                    {category.category}
                  </h3>
                  <ul class="space-y-0.5">
                    <%= for item <- category.items do %>
                      <li>
                        <.link
                          navigate={"/examples/#{item.id}"}
                          class={[
                            "flex items-center gap-3 px-3 py-2 rounded-lg text-sm transition-all",
                            if(item.active,
                              do: "bg-white/10 text-landing-text",
                              else:
                                "text-landing-muted hover:text-landing-text hover:bg-white/5 opacity-50 pointer-events-none"
                            )
                          ]}
                        >
                          <span class={[
                            "w-6 h-6 flex items-center justify-center rounded-md",
                            if(item.active,
                              do: "bg-phoenix/20 text-phoenix",
                              else: "bg-landing-elevated text-landing-muted"
                            )
                          ]}>
                            <.icon name={item.icon} class="w-3.5 h-3.5" />
                          </span>
                          <span class="flex-1">{item.title}</span>
                          <%= if not item.active do %>
                            <span class="text-[10px] uppercase tracking-wider text-landing-muted/50 bg-landing-elevated px-1.5 py-0.5 rounded">
                              Soon
                            </span>
                          <% end %>
                        </.link>
                      </li>
                    <% end %>
                  </ul>
                </div>
              <% end %>
            </nav>

            <%!-- Bottom links --%>
            <div class="mt-8 pt-6 border-t border-landing-border/30 px-3 space-y-2">
              <a
                href="https://hexdocs.pm/live_vue"
                class="flex items-center gap-2 text-sm text-landing-muted hover:text-landing-text transition-colors"
              >
                <svg
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  class="w-4 h-4"
                >
                  <path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                </svg>
                Documentation
              </a>
              <a
                href="https://github.com/Valian/live_vue"
                class="flex items-center gap-2 text-sm text-landing-muted hover:text-landing-text transition-colors"
              >
                <svg viewBox="0 0 24 24" fill="currentColor" class="w-4 h-4">
                  <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
                </svg>
                GitHub
              </a>
            </div>
          </div>
        </aside>

        <%!-- Main Content --%>
        <main class="flex-1 min-w-0">
          <div class="max-w-4xl mx-auto px-8 py-12">
            <%!-- Header --%>
            <header class="mb-8">
              <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
                <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
                <svg
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  class="w-4 h-4"
                >
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
              <div class="grid grid-cols-3 gap-4 max-sm:grid-cols-1">
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
              </div>
            </section>

            <%!-- Tabs --%>
            <div class="mb-6">
              <div class="flex gap-1 p-1 bg-landing-elevated rounded-lg w-fit">
                <button
                  phx-click="set_tab"
                  phx-value-tab="preview"
                  class={[
                    "py-2 px-4 rounded-md text-sm font-medium transition-all",
                    if(@active_tab == "preview",
                      do: "bg-landing-card text-landing-text shadow-sm",
                      else: "text-landing-muted hover:text-landing-text"
                    )
                  ]}
                >
                  Preview
                </button>
                <button
                  phx-click="set_tab"
                  phx-value-tab="liveview"
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
                </button>
                <button
                  phx-click="set_tab"
                  phx-value-tab="vue"
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
                </button>
              </div>
            </div>

            <%!-- Tab Content --%>
            <div class="bg-landing-card border border-landing-border rounded-xl overflow-hidden">
              <%= case @active_tab do %>
                <% "preview" -> %>
                  <div class="p-8 flex justify-center">
                    <div class="w-full max-w-sm">
                      <.vue v-component="examples/Counter" count={@count} v-socket={@socket} />
                    </div>
                  </div>
                <% "liveview" -> %>
                  <div class="relative">
                    <div class="flex items-center gap-3 py-3 px-4 bg-landing-elevated border-b border-landing-border">
                      <span class="w-2 h-2 rounded-full bg-phoenix"></span>
                      <span class="font-mono text-sm text-landing-muted">counter_live.ex</span>
                      <button
                        class="ml-auto p-1.5 text-landing-muted hover:text-landing-text transition-colors rounded hover:bg-white/5"
                        onclick={"navigator.clipboard.writeText(#{Jason.encode!(@elixir_source)})"}
                        title="Copy code"
                      >
                        <svg
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="2"
                          class="w-4 h-4"
                        >
                          <rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
                          <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1" />
                        </svg>
                      </button>
                    </div>
                    <div id="elixir-code" phx-hook="Highlight" class="p-4 overflow-x-auto">
                      <pre class="font-mono text-sm leading-relaxed"><code class="language-elixir" phx-no-format>{@elixir_source}</code></pre>
                    </div>
                  </div>
                <% "vue" -> %>
                  <div class="relative">
                    <div class="flex items-center gap-3 py-3 px-4 bg-landing-elevated border-b border-landing-border">
                      <span class="w-2 h-2 rounded-full bg-vue"></span>
                      <span class="font-mono text-sm text-landing-muted">Counter.vue</span>
                      <button
                        class="ml-auto p-1.5 text-landing-muted hover:text-landing-text transition-colors rounded hover:bg-white/5"
                        onclick={"navigator.clipboard.writeText(#{Jason.encode!(@vue_source)})"}
                        title="Copy code"
                      >
                        <svg
                          viewBox="0 0 24 24"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="2"
                          class="w-4 h-4"
                        >
                          <rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
                          <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1" />
                        </svg>
                      </button>
                    </div>
                    <div id="vue-code" phx-hook="Highlight" class="p-4 overflow-x-auto">
                      <pre class="font-mono text-sm leading-relaxed"><code class="language-vue" phx-no-format>{@vue_source}</code></pre>
                    </div>
                  </div>
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
                    Props flow from LiveView to Vue
                  </h3>
                  <p class="text-landing-muted text-sm leading-relaxed mb-3">
                    The <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">count</code>
                    assign in LiveView
                    becomes a prop in Vue. When the server state changes, Vue automatically re-renders with the new value.
                  </p>
                  <pre class="font-mono text-xs bg-landing-elevated p-3 rounded-lg overflow-x-auto"><code class="text-landing-text">&lt;.vue count={@count} v-component="Counter" v-socket={@socket} /&gt;</code></pre>
                </div>

                <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
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
                  <pre class="font-mono text-xs bg-landing-elevated p-3 rounded-lg overflow-x-auto"><code class="text-landing-text">const diff = ref(1)  // Local Vue state</code></pre>
                </div>

                <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
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
                  <pre
                    class="font-mono text-xs bg-landing-elevated p-3 rounded-lg overflow-x-auto"
                    phx-no-format
                  ><code class="text-landing-text" phx-no-curly-interpolation>&lt;button phx-click="inc" :phx-value-diff="diff"&gt;+{{ diff }}&lt;/button&gt;</code></pre>
                </div>
              </div>
            </section>

            <%!-- Next example --%>
            <section class="mt-12 pt-8 border-t border-landing-border">
              <div class="flex items-center justify-between">
                <div class="text-landing-muted text-sm">
                  Next up: Animated Counter with Vue transitions
                </div>
                <span class="text-landing-muted/50 text-sm">Coming soon</span>
              </div>
            </section>
          </div>
        </main>
      </div>
    </div>
    """
  end
end
