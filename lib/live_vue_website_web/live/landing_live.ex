defmodule LiveVueWebsiteWeb.LandingLive do
  use LiveVueWebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <%!-- Hero Section --%>
      <section class="relative py-20 lg:py-32">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h1 class="text-4xl font-bold tracking-tight sm:text-5xl lg:text-6xl">
              <span class="text-phoenix">Vue</span>
              inside <span class="text-phoenix">Phoenix LiveView</span>
              <br />
              <span class="text-base-content/80">with seamless end-to-end reactivity.</span>
            </h1>
            <p class="mx-auto mt-6 max-w-2xl text-lg text-base-content/70">
              Forms, uploads, streams, events — all working. Plus instant reload and SSR.
            </p>
            <div class="mt-10 flex items-center justify-center gap-4">
              <a href="https://hexdocs.pm/live_vue" class="btn btn-primary btn-lg">
                Get Started <span aria-hidden="true">&rarr;</span>
              </a>
              <a href="#examples" class="btn btn-ghost btn-lg">
                Examples
              </a>
            </div>
          </div>

          <%!-- Hero Animation Placeholder --%>
          <div class="mt-16 lg:mt-24">
            <div class="relative mx-auto max-w-4xl rounded-xl border-2 border-base-300 bg-base-200 p-8 shadow-xl">
              <div class="text-center text-sm text-base-content/50">
                [Vue Component Placeholder: HeroAnimation]
              </div>
              <%!-- Static fallback diagram --%>
              <div class="mt-6 space-y-4 font-mono text-sm">
                <%!-- Server Box --%>
                <div class="rounded-lg border-2 border-phoenix/50 bg-phoenix/5 p-4">
                  <div class="mb-2 text-xs font-semibold uppercase tracking-wide text-phoenix">
                    Server (LiveView)
                  </div>
                  <code class="text-base-content/80">
                    {"assigns = %{count: 5, user: %{name: \"Alice\"}}"}
                  </code>
                </div>

                <%!-- Arrows --%>
                <div class="flex items-center justify-center gap-8 text-base-content/40">
                  <div class="flex flex-col items-center">
                    <span class="text-xs">props</span>
                    <span class="text-lg">↓</span>
                    <span class="text-xs">(auto-sync)</span>
                  </div>
                  <div class="flex flex-col items-center">
                    <span class="text-xs">events</span>
                    <span class="text-lg">↑</span>
                    <span class="text-xs">(pushEvent)</span>
                  </div>
                </div>

                <%!-- Client Box --%>
                <div class="rounded-lg border-2 border-vue/50 bg-vue/5 p-4">
                  <div class="mb-2 text-xs font-semibold uppercase tracking-wide text-vue">
                    Client (Vue Component)
                  </div>
                  <div class="grid gap-4 sm:grid-cols-2">
                    <div>
                      <div class="text-xs text-base-content/50">props (from server)</div>
                      <code class="text-base-content/80">count: 5</code>
                    </div>
                    <div>
                      <div class="text-xs text-base-content/50">local state (Vue refs)</div>
                      <code class="text-base-content/80">filter: "all"</code>
                    </div>
                  </div>
                </div>

                <%!-- DOM Box --%>
                <div class="rounded-lg border-2 border-base-300 bg-base-100 p-4">
                  <div class="mb-2 text-xs font-semibold uppercase tracking-wide text-base-content/60">
                    DOM
                  </div>
                  <code class="text-base-content/80">{"<p>Count: 5</p>"}</code>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <%!-- Features Grid --%>
      <section class="py-20 lg:py-32">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">
              Built for the LiveView way
            </h2>
            <p class="mx-auto mt-4 max-w-2xl text-lg text-base-content/70">
              Everything you need to build rich client-side interactions while keeping server-side state management.
            </p>
          </div>

          <div class="mt-16 grid gap-8 sm:grid-cols-2 lg:grid-cols-3">
            <.feature_card
              icon="hero-bolt"
              title="End-to-End Reactivity"
              description="Props flow from LiveView assigns. Changes sync automatically."
            />
            <.feature_card
              icon="hero-wrench-screwdriver"
              title="Built for LiveView"
              description="Not a wrapper or adapter. Designed for LiveView's architecture."
            />
            <.feature_card
              icon="hero-computer-desktop"
              title="Server-Side Rendered"
              description="Vue components render on first paint. No loading flash."
            />
            <.feature_card
              icon="hero-cube"
              title="Efficient Updates"
              description="Only changed props sent via JSON patches over WebSocket."
            />
            <.feature_card
              icon="hero-code-bracket"
              title="TypeScript Ready"
              description="Full type safety for props, events, and composables."
            />
            <.feature_card
              icon="hero-rocket-launch"
              title="One-Line Install"
              description="mix igniter.install live_vue handles setup automatically."
            />
          </div>
        </div>
      </section>

      <%!-- Code Example Section --%>
      <section class="py-20 lg:py-32 bg-base-200/50">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">
              Simple mental model
            </h2>
            <p class="mx-auto mt-4 max-w-2xl text-lg text-base-content/70">
              Props in, events out. Server owns the state.
            </p>
          </div>

          <div class="mt-16 grid gap-8 lg:grid-cols-2">
            <%!-- Vue Component Code --%>
            <.code_block filename="Counter.vue" lang="vue" code={@vue_code} />

            <%!-- LiveView Code --%>
            <.code_block filename="counter_live.ex" lang="elixir" code={@elixir_code} />
          </div>
        </div>
      </section>

      <%!-- What Works Section --%>
      <section class="py-20 lg:py-32" id="examples">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">
              Everything just works
            </h2>
            <p class="mx-auto mt-4 max-w-2xl text-lg text-base-content/70">
              LiveView features you rely on, now with Vue-friendly APIs.
            </p>
          </div>

          <div class="mt-16 grid gap-12 lg:grid-cols-2">
            <.feature_block title="Forms & Validation" icon="hero-document-text">
              <p class="text-base-content/70">
                Ecto changesets work the same way.
                <code class="text-sm bg-base-200 px-1.5 py-0.5 rounded">useLiveForm()</code>
                provides the same validation flow you'd use in HEEX.
              </p>
              <div class="mt-4 text-center text-sm text-base-content/50">
                [Vue Component Placeholder: FormDemo]
              </div>
            </.feature_block>

            <.feature_block title="Streams" icon="hero-queue-list">
              <p class="text-base-content/70">
                Pass <code class="text-sm bg-base-200 px-1.5 py-0.5 rounded">@streams.items</code>
                as a prop. LiveVue applies patches efficiently.
              </p>
              <div class="mt-4 text-center text-sm text-base-content/50">
                [Vue Component Placeholder: StreamDemo]
              </div>
            </.feature_block>

            <.feature_block title="File Uploads" icon="hero-cloud-arrow-up">
              <p class="text-base-content/70">
                <code class="text-sm bg-base-200 px-1.5 py-0.5 rounded">useLiveUpload()</code>
                wraps LiveView's upload system. Same backend, Vue-friendly API.
              </p>
              <div class="mt-4 text-center text-sm text-base-content/50">
                [Vue Component Placeholder: UploadDemo]
              </div>
            </.feature_block>

            <.feature_block title="Events & Navigation" icon="hero-arrows-right-left">
              <p class="text-base-content/70">
                <code class="text-sm bg-base-200 px-1.5 py-0.5 rounded">pushEvent()</code>
                to server,
                <code class="text-sm bg-base-200 px-1.5 py-0.5 rounded">useLiveEvent()</code>
                from server. Plus
                <code class="text-sm bg-base-200 px-1.5 py-0.5 rounded">&lt;Link&gt;</code>
                for navigation.
              </p>
              <div class="mt-4 text-center text-sm text-base-content/50">
                [Vue Component Placeholder: EventsDemo]
              </div>
            </.feature_block>
          </div>
        </div>
      </section>

      <%!-- Use Cases Section --%>
      <section class="py-20 lg:py-32 bg-base-200/50">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
          <div class="grid gap-12 lg:grid-cols-2">
            <div>
              <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">
                When LiveVue makes sense
              </h2>
              <ul class="mt-8 space-y-4">
                <li class="flex items-start gap-3">
                  <.icon name="hero-check-circle" class="size-6 text-vue shrink-0 mt-0.5" />
                  <span>
                    <strong>Rich interactions</strong>
                    — Drag-and-drop, animations, complex local state
                  </span>
                </li>
                <li class="flex items-start gap-3">
                  <.icon name="hero-check-circle" class="size-6 text-vue shrink-0 mt-0.5" />
                  <span>
                    <strong>Third-party libraries</strong> — Chart.js, TipTap, Vue ecosystem packages
                  </span>
                </li>
                <li class="flex items-start gap-3">
                  <.icon name="hero-check-circle" class="size-6 text-vue shrink-0 mt-0.5" />
                  <span>
                    <strong>Team familiarity</strong> — Your team knows Vue and wants to use it
                  </span>
                </li>
                <li class="flex items-start gap-3">
                  <.icon name="hero-check-circle" class="size-6 text-vue shrink-0 mt-0.5" />
                  <span>
                    <strong>Gradual adoption</strong> — Start with one component, expand as needed
                  </span>
                </li>
              </ul>
            </div>

            <div>
              <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">
                When plain LiveView is enough
              </h2>
              <ul class="mt-8 space-y-4">
                <li class="flex items-start gap-3">
                  <.icon name="hero-minus-circle" class="size-6 text-base-content/40 shrink-0 mt-0.5" />
                  <span>Forms, tables, simple interactions</span>
                </li>
                <li class="flex items-start gap-3">
                  <.icon name="hero-minus-circle" class="size-6 text-base-content/40 shrink-0 mt-0.5" />
                  <span>Server-rendered content with minimal JS</span>
                </li>
                <li class="flex items-start gap-3">
                  <.icon name="hero-minus-circle" class="size-6 text-base-content/40 shrink-0 mt-0.5" />
                  <span>When you don't need the Vue runtime (~34kb gzipped)</span>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </section>

      <%!-- Two Approaches Section --%>
      <section class="py-20 lg:py-32">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">
              Two approaches, one library
            </h2>
            <p class="mx-auto mt-4 max-w-2xl text-lg text-base-content/70">
              Use Vue as islands within HEEX, or let Vue render everything.
            </p>
          </div>

          <div class="mt-16 grid gap-8 lg:grid-cols-2">
            <div class="rounded-xl border border-base-300 bg-base-100 p-8">
              <div class="flex items-center gap-3">
                <span class="inline-flex h-10 w-10 items-center justify-center rounded-lg bg-phoenix/10">
                  <.icon name="hero-puzzle-piece" class="size-6 text-phoenix" />
                </span>
                <h3 class="text-xl font-semibold">Embedded Components</h3>
              </div>
              <p class="mt-4 text-base-content/70">
                Vue handles interactive islands. Phoenix renders the layout.
              </p>
              <pre class="mt-6 overflow-x-auto rounded-lg bg-base-200 p-4 text-sm"><code>{@embedded_code}</code></pre>
            </div>

            <div class="rounded-xl border border-base-300 bg-base-100 p-8">
              <div class="flex items-center gap-3">
                <span class="inline-flex h-10 w-10 items-center justify-center rounded-lg bg-vue/10">
                  <.icon name="hero-square-3-stack-3d" class="size-6 text-vue" />
                </span>
                <h3 class="text-xl font-semibold">Full Vue Layouts</h3>
              </div>
              <p class="mt-4 text-base-content/70">
                Vue renders everything. LiveView manages state and routing.
              </p>
              <pre class="mt-6 overflow-x-auto rounded-lg bg-base-200 p-4 text-sm"><code>{@spa_code}</code></pre>
            </div>
          </div>
        </div>
      </section>

      <%!-- Quick Start Section --%>
      <section class="py-20 lg:py-32 bg-base-200/50">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">
              Get started in minutes
            </h2>
          </div>

          <div class="mt-12 mx-auto max-w-2xl space-y-6">
            <div class="rounded-xl border border-base-300 bg-base-100 overflow-hidden">
              <div class="border-b border-base-300 bg-base-200 px-4 py-3">
                <span class="text-sm font-medium">New project</span>
              </div>
              <pre class="overflow-x-auto p-4 text-sm"><code>mix igniter.new my_app --with phx.new --install live_vue</code></pre>
            </div>

            <div class="rounded-xl border border-base-300 bg-base-100 overflow-hidden">
              <div class="border-b border-base-300 bg-base-200 px-4 py-3">
                <span class="text-sm font-medium">Existing project</span>
              </div>
              <pre class="overflow-x-auto p-4 text-sm"><code>mix igniter.install live_vue</code></pre>
            </div>

            <div class="rounded-xl border border-base-300 bg-base-100 overflow-hidden">
              <div class="border-b border-base-300 bg-base-200 px-4 py-3">
                <span class="text-sm font-medium">Create a component</span>
              </div>
              <pre class="overflow-x-auto p-4 text-sm"><code>{@quickstart_component}</code></pre>
            </div>

            <div class="rounded-xl border border-base-300 bg-base-100 overflow-hidden">
              <div class="border-b border-base-300 bg-base-200 px-4 py-3">
                <span class="text-sm font-medium">Use it</span>
              </div>
              <pre class="overflow-x-auto p-4 text-sm"><code>{"<.vue count={@count} v-component=\"Counter\" v-socket={@socket} />"}</code></pre>
            </div>
          </div>
        </div>
      </section>

      <%!-- Comparisons Section --%>
      <section class="py-20 lg:py-32">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">
              How it compares
            </h2>
          </div>

          <div class="mt-16 grid gap-8 md:grid-cols-3">
            <div class="rounded-xl border border-base-300 bg-base-100 p-6">
              <h3 class="text-lg font-semibold">vs Pure LiveView</h3>
              <p class="mt-4 text-sm text-base-content/70">
                LiveView is excellent for most UI work. LiveVue adds Vue when you need complex client-side state, Vue ecosystem libraries, or component patterns that map better to Vue.
              </p>
            </div>

            <div class="rounded-xl border border-base-300 bg-base-100 p-6">
              <h3 class="text-lg font-semibold">vs Inertia.js</h3>
              <p class="mt-4 text-sm text-base-content/70">
                Different goals. Inertia replaces LiveView with a request/response model. LiveVue keeps LiveView's WebSocket connection and real-time capabilities.
              </p>
            </div>

            <div class="rounded-xl border border-base-300 bg-base-100 p-6">
              <h3 class="text-lg font-semibold">vs LiveSvelte / LiveReact</h3>
              <p class="mt-4 text-sm text-base-content/70">
                Same idea, different framework. Choose based on team preference and ecosystem needs.
              </p>
            </div>
          </div>
        </div>
      </section>

      <%!-- CTA Section --%>
      <section class="py-20 lg:py-32 bg-gradient-to-br from-phoenix/10 via-transparent to-vue/10">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
          <div class="text-center">
            <h2 class="text-3xl font-bold tracking-tight sm:text-4xl">
              Ready to try LiveVue?
            </h2>
            <p class="mx-auto mt-4 max-w-2xl text-lg text-base-content/70">
              Check out the docs, browse examples, or jump straight in.
            </p>
            <div class="mt-10 flex items-center justify-center gap-4 flex-wrap">
              <a href="https://hexdocs.pm/live_vue" class="btn btn-primary btn-lg">
                Documentation
              </a>
              <a href="https://github.com/Valian/live_vue" class="btn btn-ghost btn-lg">
                <svg viewBox="0 0 24 24" aria-hidden="true" class="h-5 w-5 mr-2">
                  <path
                    fill="currentColor"
                    fill-rule="evenodd"
                    clip-rule="evenodd"
                    d="M12 0C5.37 0 0 5.506 0 12.303c0 5.445 3.435 10.043 8.205 11.674.6.107.825-.262.825-.585 0-.292-.015-1.261-.015-2.291C6 21.67 5.22 20.346 4.98 19.654c-.135-.354-.72-1.446-1.23-1.738-.42-.23-1.02-.8-.015-.815.945-.015 1.62.892 1.845 1.261 1.08 1.86 2.805 1.338 3.495 1.015.105-.8.42-1.338.765-1.645-2.67-.308-5.46-1.37-5.46-6.075 0-1.338.465-2.446 1.23-3.307-.12-.308-.54-1.569.12-3.26 0 0 1.005-.323 3.3 1.26.96-.276 1.98-.415 3-.415s2.04.139 3 .416c2.295-1.6 3.3-1.261 3.3-1.261.66 1.691.24 2.952.12 3.26.765.861 1.23 1.953 1.23 3.307 0 4.721-2.805 5.767-5.475 6.075.435.384.81 1.122.81 2.276 0 1.645-.015 2.968-.015 3.383 0 .323.225.707.825.585a12.047 12.047 0 0 0 5.919-4.489A12.536 12.536 0 0 0 24 12.304C24 5.505 18.63 0 12 0Z"
                  />
                </svg>
                GitHub
              </a>
              <a href="https://hex.pm/packages/live_vue" class="btn btn-ghost btn-lg">
                Hex.pm
              </a>
            </div>
          </div>
        </div>
      </section>

      <%!-- Footer --%>
      <footer class="border-t border-base-300 py-12">
        <div class="mx-auto max-w-6xl px-4 sm:px-6 lg:px-8">
          <div class="flex flex-col items-center justify-between gap-4 sm:flex-row">
            <div class="flex items-center gap-2">
              <span class="text-lg font-semibold">LiveVue</span>
              <span class="text-sm text-base-content/50">
                Built with <span class="text-phoenix">Phoenix</span>
                + <span class="text-vue">Vue</span>
              </span>
            </div>
            <div class="flex items-center gap-6 text-sm text-base-content/70">
              <a href="https://github.com/Valian/live_vue" class="hover:text-base-content">GitHub</a>
              <a href="https://hexdocs.pm/live_vue" class="hover:text-base-content">Docs</a>
              <a href="https://hex.pm/packages/live_vue" class="hover:text-base-content">Hex.pm</a>
            </div>
          </div>
        </div>
      </footer>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    vue_code = """
    <script setup lang="ts">
    import { ref } from "vue"

    const props = defineProps<{ count: number }>()
    const diff = ref(1)
    </script>

    <template>
      <p>Count: {{ props.count }}</p>
      <input v-model.number="diff" type="range" />
      <button phx-click="inc" :phx-value-diff="diff">
        +{{ diff }}
      </button>
    </template>
    """

    elixir_code = """
    defmodule MyAppWeb.CounterLive do
      use MyAppWeb, :live_view

      def render(assigns) do
        ~H\"\"\"
        <.vue count={@count}
              v-component="Counter"
              v-socket={@socket} />
        \"\"\"
      end

      def mount(_params, _session, socket) do
        {:ok, assign(socket, count: 0)}
      end

      def handle_event("inc", %{"diff" => diff}, socket) do
        {:noreply, update(socket, :count, &(&1 + diff))}
      end
    end
    """

    embedded_code = """
    def render(assigns) do
      ~H\"\"\"
      <Layouts.app flash={@flash}>
        <h1>Dashboard</h1>
        <.vue data={@metrics}
              v-component="Chart"
              v-socket={@socket} />
      </Layouts.app>
      \"\"\"
    end
    """

    spa_code = """
    def render(assigns) do
      ~H\"\"\"
      <.vue v-component="App"
            v-socket={@socket}
            {@props} />
      \"\"\"
    end
    """

    quickstart_component = """
    <!-- assets/vue/Counter.vue -->
    <script setup lang="ts">
    const props = defineProps<{ count: number }>()
    </script>

    <template>
      <p>Count: {{ props.count }}</p>
      <button phx-click="increment">+1</button>
    </template>
    """

    socket =
      assign(socket,
        vue_code: String.trim(vue_code),
        elixir_code: String.trim(elixir_code),
        embedded_code: String.trim(embedded_code),
        spa_code: String.trim(spa_code),
        quickstart_component: String.trim(quickstart_component)
      )

    {:ok, socket}
  end

  # Component helpers

  attr :icon, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: true

  defp feature_card(assigns) do
    ~H"""
    <div class="rounded-xl border border-base-300 bg-base-100 p-6 transition hover:border-primary/50 hover:shadow-lg">
      <div class="inline-flex h-12 w-12 items-center justify-center rounded-lg bg-primary/10">
        <.icon name={@icon} class="size-6 text-primary" />
      </div>
      <h3 class="mt-4 text-lg font-semibold">{@title}</h3>
      <p class="mt-2 text-sm text-base-content/70">{@description}</p>
    </div>
    """
  end

  attr :title, :string, required: true
  attr :icon, :string, required: true
  slot :inner_block, required: true

  defp feature_block(assigns) do
    ~H"""
    <div class="rounded-xl border border-base-300 bg-base-100 p-6">
      <div class="flex items-center gap-3">
        <.icon name={@icon} class="size-6 text-primary" />
        <h3 class="text-lg font-semibold">{@title}</h3>
      </div>
      <div class="mt-4">
        {render_slot(@inner_block)}
      </div>
    </div>
    """
  end

  attr :filename, :string, required: true
  attr :lang, :string, required: true
  attr :code, :string, required: true

  defp code_block(assigns) do
    dot_color =
      case assigns.lang do
        "vue" -> "bg-vue"
        "elixir" -> "bg-phoenix"
        _ -> "bg-base-content/50"
      end

    assigns = assign(assigns, :dot_color, dot_color)

    ~H"""
    <div class="rounded-xl border border-base-300 bg-base-100 overflow-hidden">
      <div class="flex items-center gap-2 border-b border-base-300 bg-base-200 px-4 py-3">
        <span class={["inline-flex h-3 w-3 rounded-full", @dot_color]}></span>
        <span class="text-sm font-medium">{@filename}</span>
      </div>
      <pre class="overflow-x-auto p-4 text-sm"><code class={"language-#{@lang}"}>{@code}</code></pre>
    </div>
    """
  end
end
