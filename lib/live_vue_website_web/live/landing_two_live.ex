defmodule LiveVueWebsiteWeb.LandingTwoLive do
  use LiveVueWebsiteWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       count: 0,
       page_title: "LiveVue – The Bridge Between Worlds"
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

  defp vue_code_example do
    """
    <script setup lang="ts">
    import { ref } from "vue"

    // Props from LiveView
    const props = defineProps<{ count: number }>()

    // Local Vue state
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
  end

  defp elixir_code_example do
    ~s'''
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
    end
    '''
  end

  def render(assigns) do
    ~H"""
    <div class="bg-landing-deep text-landing-text font-[Inter,system-ui,sans-serif] leading-relaxed overflow-x-hidden">
      <%!-- HERO SECTION --%>
      <section class="relative min-h-screen flex flex-col px-[clamp(1.5rem,5vw,4rem)]">
        <div class="absolute inset-0 overflow-hidden pointer-events-none">
          <div class="absolute rounded-full blur-[100px] opacity-40 animate-[float_20s_ease-in-out_infinite] w-[600px] h-[600px] bg-[radial-gradient(circle,var(--color-phoenix)_0%,transparent_70%)] -top-[200px] -right-[100px]">
          </div>
          <div class="absolute rounded-full blur-[100px] opacity-40 animate-[float_20s_ease-in-out_infinite] w-[500px] h-[500px] bg-[radial-gradient(circle,var(--color-vue)_0%,transparent_70%)] -bottom-[150px] -left-[100px] [animation-delay:-10s]">
          </div>
          <div class="absolute inset-0 bg-[linear-gradient(rgba(255,255,255,0.02)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.02)_1px,transparent_1px)] bg-[size:60px_60px] [mask-image:radial-gradient(ellipse_at_center,black_0%,transparent_70%)]">
          </div>
        </div>

        <nav class="relative flex justify-between items-center py-6 z-10">
          <a
            href="/"
            class="flex items-center gap-3 font-serif text-[1.75rem] no-underline tracking-tight"
          >
            <img src="/images/live_vue_logo_rounded.png" alt="LiveVue" class="h-10 w-10 rounded-lg" />
            <span><span class="text-phoenix">Live</span><span class="text-vue">Vue</span></span>
          </a>
          <div class="flex items-center gap-2">
            <a
              href="#features"
              class="py-2 px-4 text-landing-muted no-underline text-sm transition-colors rounded-md hover:text-landing-text hover:bg-white/5"
            >
              Features
            </a>
            <a
              href="#code"
              class="py-2 px-4 text-landing-muted no-underline text-sm transition-colors rounded-md hover:text-landing-text hover:bg-white/5"
            >
              Code
            </a>
            <a
              href="https://hexdocs.pm/live_vue"
              class="py-2 px-4 text-landing-muted no-underline text-sm transition-colors rounded-md hover:text-landing-text hover:bg-white/5"
            >
              Docs
            </a>
            <a
              href="https://github.com/Valian/live_vue"
              class="p-2 text-landing-muted no-underline text-sm transition-colors rounded-md hover:text-landing-text hover:bg-white/5 flex items-center"
            >
              <svg viewBox="0 0 24 24" fill="currentColor" class="w-5 h-5">
                <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
              </svg>
            </a>
          </div>
        </nav>

        <div class="relative flex-1 flex flex-col justify-center max-w-[800px] py-16 z-5">
          <div class="inline-flex items-center gap-2 py-1.5 px-4 bg-white/5 border border-landing-border rounded-full text-xs text-landing-muted w-fit mb-8 backdrop-blur-lg">
            <span class="w-1.5 h-1.5 bg-vue rounded-full animate-[pulse-dot_2s_ease-in-out_infinite]">
            </span>
            Phoenix LiveView + Vue.js
          </div>

          <h1 class="font-serif text-[clamp(3rem,8vw,5.5rem)] font-normal leading-none tracking-tight mb-6">
            <span class="block">The bridge between</span>
            <span class="block italic">
              <span class="text-phoenix">server</span> and <span class="text-vue">client</span>
            </span>
          </h1>

          <p class="text-xl text-landing-muted max-w-[540px] mb-10 leading-relaxed">
            Vue components with end-to-end reactivity. Server owns the state.
            Props flow down. Events bubble up. No API layer. No state sync bugs.
          </p>

          <div class="flex gap-4 flex-wrap mb-12">
            <a
              href="https://hexdocs.pm/live_vue"
              class="inline-flex items-center gap-2 py-3.5 px-7 bg-gradient-to-br from-phoenix to-phoenix-glow text-white no-underline font-medium rounded-lg transition-all duration-200 shadow-[0_4px_20px_rgba(253,79,0,0.3)] hover:-translate-y-0.5 hover:shadow-[0_6px_30px_rgba(253,79,0,0.4)] group"
            >
              Get Started
              <svg
                class="w-[18px] h-[18px] transition-transform duration-200 group-hover:translate-x-1"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              >
                <path d="M5 12h14M12 5l7 7-7 7" />
              </svg>
            </a>
            <a
              href="#code"
              class="inline-flex items-center py-3.5 px-7 bg-transparent border border-landing-border text-landing-text no-underline font-medium rounded-lg transition-all duration-200 hover:bg-white/5 hover:border-landing-muted"
            >
              See the code
            </a>
          </div>

          <div class="flex items-center gap-2 py-3 px-4 bg-landing-elevated border border-landing-border rounded-lg w-fit">
            <code class="font-mono text-sm text-vue">mix igniter.install live_vue</code>
            <button
              class="bg-none border-none p-1 cursor-pointer text-landing-muted transition-colors flex items-center hover:text-landing-text"
              onclick="navigator.clipboard.writeText('mix igniter.install live_vue')"
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
        </div>

        <div class="absolute right-0 top-1/2 -translate-y-1/2 w-[45%] max-w-[600px] z-1 hidden lg:block">
          <.vue v-component="DataFlowHero" v-socket={@socket} />
        </div>

        <div class="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2 text-landing-muted text-xs uppercase tracking-widest animate-[bounce-scroll_2s_ease-in-out_infinite]">
          <span>Scroll to explore</span>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-5 h-5">
            <path d="M12 5v14M5 12l7 7 7-7" />
          </svg>
        </div>
      </section>

      <%!-- FEATURES SECTION --%>
      <section id="features" class="py-32 px-[clamp(1.5rem,5vw,4rem)] bg-landing-bg">
        <div class="text-center mb-16">
          <span class="inline-block font-mono text-xs uppercase tracking-[0.15em] text-vue mb-4">
            Why LiveVue
          </span>
          <h2 class="font-serif text-[clamp(2rem,5vw,3.5rem)] font-normal leading-tight tracking-tight">
            Everything you need.<br />Nothing you don't.
          </h2>
        </div>

        <div class="grid grid-cols-[repeat(auto-fit,minmax(280px,1fr))] gap-6 max-w-[1200px] mx-auto">
          <div class="col-span-full grid grid-cols-[auto_1fr] gap-8 items-center p-8 bg-[linear-gradient(135deg,rgba(253,79,0,0.05)_0%,rgba(66,184,131,0.05)_100%)] border border-[rgba(253,79,0,0.2)] rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted max-sm:grid-cols-1 max-sm:text-center">
            <div class="w-[120px] h-[120px]">
              <svg
                viewBox="0 0 48 48"
                fill="none"
                class="w-full h-full animate-[spin-slow_20s_linear_infinite]"
              >
                <circle
                  cx="24"
                  cy="24"
                  r="20"
                  stroke="url(#gradient-phoenix)"
                  stroke-width="2"
                  stroke-dasharray="4 4"
                />
                <circle cx="24" cy="24" r="12" stroke="url(#gradient-vue)" stroke-width="2" />
                <circle cx="24" cy="24" r="4" fill="url(#gradient-mix)" />
                <defs>
                  <linearGradient id="gradient-phoenix" x1="0" y1="0" x2="48" y2="48">
                    <stop offset="0%" stop-color="#FD4F00" />
                    <stop offset="100%" stop-color="#FF8A50" />
                  </linearGradient>
                  <linearGradient id="gradient-vue" x1="0" y1="0" x2="48" y2="48">
                    <stop offset="0%" stop-color="#42b883" />
                    <stop offset="100%" stop-color="#35495e" />
                  </linearGradient>
                  <linearGradient id="gradient-mix" x1="0" y1="0" x2="48" y2="48">
                    <stop offset="0%" stop-color="#FD4F00" />
                    <stop offset="100%" stop-color="#42b883" />
                  </linearGradient>
                </defs>
              </svg>
            </div>
            <div>
              <h3 class="font-serif text-[1.75rem] mb-3 tracking-tight">End-to-End Reactivity</h3>
              <p class="text-landing-muted text-lg leading-relaxed max-w-[500px]">
                LiveView assigns become Vue props automatically. When server state changes, Vue re-renders.
                When Vue emits events, LiveView handles them. The loop is complete.
              </p>
            </div>
          </div>

          <div class="p-8 bg-landing-card border border-landing-border rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted">
            <div class="text-3xl mb-4">🖥️</div>
            <h3 class="font-serif text-xl mb-2 tracking-tight">Server-Side Rendered</h3>
            <p class="text-landing-muted text-[0.95rem] leading-relaxed">
              Vue components render on first paint. No loading flash. Full SEO.
            </p>
          </div>

          <div class="p-8 bg-landing-card border border-landing-border rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted">
            <div class="text-3xl mb-4">📦</div>
            <h3 class="font-serif text-xl mb-2 tracking-tight">Efficient Updates</h3>
            <p class="text-landing-muted text-[0.95rem] leading-relaxed">
              JSON patches over WebSocket. Only changed props are sent.
            </p>
          </div>

          <div class="p-8 bg-landing-card border border-landing-border rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted">
            <div class="text-3xl mb-4">🚀</div>
            <h3 class="font-serif text-xl mb-2 tracking-tight">One-Line Install</h3>
            <p class="text-landing-muted text-[0.95rem] leading-relaxed">
              Igniter handles the setup. TypeScript, Vite, SSR — all configured.
            </p>
          </div>

          <div class="p-8 bg-landing-card border border-landing-border rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted">
            <div class="text-3xl mb-4">🎯</div>
            <h3 class="font-serif text-xl mb-2 tracking-tight">Streams & Forms</h3>
            <p class="text-landing-muted text-[0.95rem] leading-relaxed">
              Phoenix Streams work transparently. Ecto changesets power validation.
            </p>
          </div>

          <div class="p-8 bg-landing-card border border-landing-border rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted">
            <div class="text-3xl mb-4">📁</div>
            <h3 class="font-serif text-xl mb-2 tracking-tight">File Uploads</h3>
            <p class="text-landing-muted text-[0.95rem] leading-relaxed">
              useLiveUpload() wraps LiveView's upload system with a Vue-friendly API.
            </p>
          </div>

          <div class="p-8 bg-landing-card border border-landing-border rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted">
            <div class="text-3xl mb-4">🦄</div>
            <h3 class="font-serif text-xl mb-2 tracking-tight">Vue Ecosystem</h3>
            <p class="text-landing-muted text-[0.95rem] leading-relaxed">
              Use any Vue library. Chart.js, TipTap, Headless UI — they all work.
            </p>
          </div>
        </div>
      </section>

      <%!-- INTERACTIVE DEMO SECTION --%>
      <section
        id="demo"
        class="relative py-32 px-[clamp(1.5rem,5vw,4rem)] bg-landing-deep overflow-hidden before:content-[''] before:absolute before:top-0 before:left-0 before:right-0 before:h-px before:bg-gradient-to-r before:from-transparent before:via-landing-border before:to-transparent"
      >
        <div class="max-w-[1000px] mx-auto">
          <div class="text-center mb-16">
            <span class="inline-block font-mono text-xs uppercase tracking-[0.15em] text-vue mb-4">
              Try it live
            </span>
            <h2 class="font-serif text-[clamp(2rem,5vw,3.5rem)] font-normal leading-tight tracking-tight">
              Server state meets<br />client interactivity
            </h2>
          </div>

          <div class="grid grid-cols-2 gap-16 items-center max-md:grid-cols-1 max-md:gap-8">
            <div class="flex justify-center">
              <.vue v-component="CounterDemo" count={@count} v-socket={@socket} />
            </div>

            <div class="flex flex-col gap-8">
              <div class="flex gap-6 items-start">
                <div class="font-mono text-xs text-phoenix py-1 px-2 bg-phoenix/10 rounded shrink-0">
                  01
                </div>
                <div class="flex flex-col gap-1">
                  <strong class="text-landing-text font-medium">
                    The count lives on the server.
                  </strong>
                  <span class="text-landing-muted text-sm">
                    LiveView owns {@count}. Vue receives it as a prop.
                  </span>
                </div>
              </div>
              <div class="flex gap-6 items-start">
                <div class="font-mono text-xs text-phoenix py-1 px-2 bg-phoenix/10 rounded shrink-0">
                  02
                </div>
                <div class="flex flex-col gap-1">
                  <strong class="text-landing-text font-medium">
                    The slider is local Vue state.
                  </strong>
                  <span class="text-landing-muted text-sm">
                    No server round-trip for UI-only state.
                  </span>
                </div>
              </div>
              <div class="flex gap-6 items-start">
                <div class="font-mono text-xs text-phoenix py-1 px-2 bg-phoenix/10 rounded shrink-0">
                  03
                </div>
                <div class="flex flex-col gap-1">
                  <strong class="text-landing-text font-medium">
                    phx-click triggers handle_event.
                  </strong>
                  <span class="text-landing-muted text-sm">
                    Vue template, LiveView handler. Seamless.
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <%!-- CODE SECTION --%>
      <section id="code" class="py-32 px-[clamp(1.5rem,5vw,4rem)] bg-landing-bg">
        <div class="max-w-[1100px] mx-auto">
          <div class="text-center mb-16">
            <span class="inline-block font-mono text-xs uppercase tracking-[0.15em] text-vue mb-4">
              The mental model
            </span>
            <h2 class="font-serif text-[clamp(2rem,5vw,3.5rem)] font-normal leading-tight tracking-tight">
              Props in. Events out.<br />Server owns the state.
            </h2>
          </div>

          <div
            id="code-examples"
            phx-hook="Highlight"
            class="grid grid-cols-[repeat(auto-fit,minmax(400px,1fr))] gap-8 max-[900px]:grid-cols-1"
          >
            <div class="bg-landing-card border border-landing-border rounded-xl overflow-hidden">
              <div class="flex items-center gap-3 py-4 px-6 bg-landing-elevated border-b border-landing-border">
                <span class="w-2.5 h-2.5 rounded-full bg-vue"></span>
                <span class="font-mono text-[0.85rem] text-landing-text">Counter.vue</span>
                <span class="ml-auto text-[0.7rem] uppercase tracking-wide py-1 px-2 bg-white/5 rounded text-landing-muted">
                  Vue Component
                </span>
              </div>
              <pre class="p-6 m-0 overflow-x-auto font-mono text-[0.85rem] leading-relaxed whitespace-pre"><code class="language-vue" phx-no-format>{vue_code_example()}</code></pre>
            </div>

            <div class="bg-landing-card border border-landing-border rounded-xl overflow-hidden">
              <div class="flex items-center gap-3 py-4 px-6 bg-landing-elevated border-b border-landing-border">
                <span class="w-2.5 h-2.5 rounded-full bg-phoenix"></span>
                <span class="font-mono text-[0.85rem] text-landing-text">counter_live.ex</span>
                <span class="ml-auto text-[0.7rem] uppercase tracking-wide py-1 px-2 bg-white/5 rounded text-landing-muted">
                  LiveView
                </span>
              </div>
              <pre class="p-6 m-0 overflow-x-auto font-mono text-[0.85rem] leading-relaxed whitespace-pre"><code class="language-elixir" phx-no-format>{elixir_code_example()}</code></pre>
            </div>
          </div>

          <div class="mt-12 relative">
            <div class="h-0.5 bg-gradient-to-r from-phoenix to-vue rounded-sm"></div>
            <div class="flex justify-between mt-4">
              <span class="flex items-center gap-2 font-mono text-xs uppercase tracking-wide text-phoenix">
                <svg
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  class="w-4 h-4"
                >
                  <path d="M12 5v14M5 12l7 7 7-7" />
                </svg>
                Props
              </span>
              <span class="flex items-center gap-2 font-mono text-xs uppercase tracking-wide text-vue">
                <svg
                  viewBox="0 0 24 24"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  class="w-4 h-4"
                >
                  <path d="M12 19V5M5 12l7-7 7 7" />
                </svg>
                Events
              </span>
            </div>
          </div>
        </div>
      </section>

      <%!-- WHEN TO USE LIVEVUE SECTION --%>
      <section class="py-24 px-[clamp(1.5rem,5vw,4rem)] bg-landing-deep">
        <div class="max-w-[700px] mx-auto">
          <div class="text-center mb-12">
            <span class="inline-block font-mono text-xs uppercase tracking-[0.15em] text-vue mb-4">
              When to reach for LiveVue
            </span>
            <h2 class="font-serif text-[clamp(2rem,5vw,3rem)] font-normal leading-tight tracking-tight mb-6">
              LiveView is great.<br />But sometimes not enough.
            </h2>
            <p class="text-landing-muted text-lg leading-relaxed">
              For most apps, LiveView handles everything. But when you need rich client-side
              interactions or want to tap into the Vue ecosystem, LiveVue bridges the gap.
            </p>
          </div>

          <div class="grid grid-cols-2 gap-6 max-sm:grid-cols-1">
            <div class="p-8 bg-landing-card border border-landing-border rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted">
              <div class="text-3xl mb-4">🎨</div>
              <h3 class="font-serif text-xl mb-2 tracking-tight">Rich Interactions</h3>
              <p class="text-landing-muted text-[0.95rem] leading-relaxed">
                Drag-drop, animations, complex local state that doesn't need the server.
              </p>
            </div>
            <div class="p-8 bg-landing-card border border-landing-border rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted">
              <div class="text-3xl mb-4">📦</div>
              <h3 class="font-serif text-xl mb-2 tracking-tight">Vue Ecosystem</h3>
              <p class="text-landing-muted text-[0.95rem] leading-relaxed">
                Chart.js, TipTap, Headless UI — any Vue package works out of the box.
              </p>
            </div>
            <div class="p-8 bg-landing-card border border-landing-border rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted">
              <div class="text-3xl mb-4">👥</div>
              <h3 class="font-serif text-xl mb-2 tracking-tight">Team Familiarity</h3>
              <p class="text-landing-muted text-[0.95rem] leading-relaxed">
                Your frontend team already knows Vue. Let them use what they know.
              </p>
            </div>
            <div class="p-8 bg-landing-card border border-landing-border rounded-xl transition-all duration-300 hover:-translate-y-1 hover:border-landing-muted">
              <div class="text-3xl mb-4">🌱</div>
              <h3 class="font-serif text-xl mb-2 tracking-tight">Gradual Adoption</h3>
              <p class="text-landing-muted text-[0.95rem] leading-relaxed">
                Start with one component. Expand as needed. No big rewrites.
              </p>
            </div>
          </div>
        </div>
      </section>

      <%!-- FOOTER CTA --%>
      <section class="relative py-32 px-[clamp(1.5rem,5vw,4rem)] text-center overflow-hidden">
        <div class="absolute inset-0 pointer-events-none">
          <div class="absolute rounded-full blur-[100px] w-[400px] h-[400px] opacity-30 bg-[radial-gradient(circle,var(--color-phoenix)_0%,transparent_70%)] -top-[100px] -left-[100px]">
          </div>
          <div class="absolute rounded-full blur-[100px] w-[400px] h-[400px] opacity-30 bg-[radial-gradient(circle,var(--color-vue)_0%,transparent_70%)] -bottom-[100px] -right-[100px]">
          </div>
        </div>
        <div class="relative z-1 max-w-[600px] mx-auto">
          <h2 class="font-serif text-[clamp(2rem,5vw,3rem)] font-normal mb-4 tracking-tight">
            Ready to bridge the gap?
          </h2>
          <p class="text-landing-muted text-lg mb-8">
            One command. Full TypeScript. SSR included. Start building.
          </p>
          <div class="inline-block py-4 px-8 bg-landing-elevated border border-landing-border rounded-lg font-mono text-base text-vue mb-10">
            <code>mix igniter.install live_vue</code>
          </div>
          <div class="flex gap-4 justify-center flex-wrap">
            <a
              href="https://hexdocs.pm/live_vue"
              class="inline-flex items-center gap-2 py-3.5 px-7 bg-gradient-to-br from-phoenix to-phoenix-glow text-white no-underline font-medium rounded-lg transition-all duration-200 shadow-[0_4px_20px_rgba(253,79,0,0.3)] hover:-translate-y-0.5 hover:shadow-[0_6px_30px_rgba(253,79,0,0.4)] group"
            >
              Read the docs
              <svg
                class="w-[18px] h-[18px] transition-transform duration-200 group-hover:translate-x-1"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              >
                <path d="M5 12h14M12 5l7 7-7 7" />
              </svg>
            </a>
            <a
              href="https://github.com/Valian/live_vue"
              class="inline-flex items-center py-3.5 px-7 bg-transparent border border-landing-border text-landing-text no-underline font-medium rounded-lg transition-all duration-200 hover:bg-white/5 hover:border-landing-muted"
            >
              View on GitHub
            </a>
          </div>
        </div>
      </section>

      <%!-- FOOTER --%>
      <footer class="py-12 px-[clamp(1.5rem,5vw,4rem)] border-t border-landing-border">
        <div class="max-w-[1200px] mx-auto flex justify-between items-center flex-wrap gap-6 max-sm:flex-col max-sm:text-center">
          <div class="flex items-center gap-2 font-serif text-xl">
            <img src="/images/live_vue_logo_rounded.png" alt="LiveVue" class="h-8 w-8 rounded-md" />
            <span class="text-phoenix">Live</span><span class="text-vue">Vue</span>
          </div>
          <div class="flex gap-8">
            <a
              href="https://hexdocs.pm/live_vue"
              class="text-landing-muted no-underline text-sm transition-colors hover:text-landing-text"
            >
              Documentation
            </a>
            <a
              href="https://github.com/Valian/live_vue"
              class="text-landing-muted no-underline text-sm transition-colors hover:text-landing-text"
            >
              GitHub
            </a>
            <a
              href="https://hex.pm/packages/live_vue"
              class="text-landing-muted no-underline text-sm transition-colors hover:text-landing-text"
            >
              Hex.pm
            </a>
          </div>
          <div class="text-landing-muted text-xs">
            Built with Phoenix LiveView + Vue.js
          </div>
        </div>
      </footer>
    </div>
    """
  end
end
