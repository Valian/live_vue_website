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
    <div class="landing-two">
      <%!-- HERO SECTION --%>
      <section class="hero-section">
        <div class="hero-bg">
          <div class="gradient-orb orb-phoenix"></div>
          <div class="gradient-orb orb-vue"></div>
          <div class="grid-overlay"></div>
        </div>

        <nav class="hero-nav">
          <a href="/" class="nav-logo">
            <span class="logo-phoenix">Live</span><span class="logo-vue">Vue</span>
          </a>
          <div class="nav-links">
            <a href="#features" class="nav-link">Features</a>
            <a href="#code" class="nav-link">Code</a>
            <a href="https://hexdocs.pm/live_vue" class="nav-link">Docs</a>
            <a href="https://github.com/Valian/live_vue" class="nav-link nav-link-github">
              <svg viewBox="0 0 24 24" fill="currentColor" class="github-icon">
                <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z" />
              </svg>
            </a>
          </div>
        </nav>

        <div class="hero-content">
          <div class="hero-badge">
            <span class="badge-dot"></span> Phoenix LiveView + Vue.js
          </div>

          <h1 class="hero-title">
            <span class="title-line">The bridge between</span>
            <span class="title-line title-highlight">
              <span class="text-phoenix">server</span> and <span class="text-vue">client</span>
            </span>
          </h1>

          <p class="hero-description">
            Vue components with end-to-end reactivity. Server owns the state.
            Props flow down. Events bubble up. No API layer. No state sync bugs.
          </p>

          <div class="hero-ctas">
            <a href="https://hexdocs.pm/live_vue" class="cta-primary">
              Get Started
              <svg
                class="cta-arrow"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              >
                <path d="M5 12h14M12 5l7 7-7 7" />
              </svg>
            </a>
            <a href="#code" class="cta-secondary">
              See the code
            </a>
          </div>

          <div class="hero-install">
            <code class="install-code">mix igniter.install live_vue</code>
            <button
              class="install-copy"
              onclick="navigator.clipboard.writeText('mix igniter.install live_vue')"
            >
              <svg
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                class="copy-icon"
              >
                <rect x="9" y="9" width="13" height="13" rx="2" ry="2" />
                <path d="M5 15H4a2 2 0 01-2-2V4a2 2 0 012-2h9a2 2 0 012 2v1" />
              </svg>
            </button>
          </div>
        </div>

        <div class="hero-visual">
          <.vue v-component="DataFlowHero" v-socket={@socket} />
        </div>

        <div class="scroll-indicator">
          <span>Scroll to explore</span>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M12 5v14M5 12l7 7 7-7" />
          </svg>
        </div>
      </section>

      <%!-- FEATURES SECTION --%>
      <section id="features" class="features-section">
        <div class="section-header">
          <span class="section-label">Why LiveVue</span>
          <h2 class="section-title">Everything you need.<br />Nothing you don't.</h2>
        </div>

        <div class="features-grid">
          <div class="feature-card feature-hero-card">
            <div class="feature-icon-large">
              <svg viewBox="0 0 48 48" fill="none" class="icon-reactive">
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
            <h3 class="feature-title-large">End-to-End Reactivity</h3>
            <p class="feature-desc-large">
              LiveView assigns become Vue props automatically. When server state changes, Vue re-renders.
              When Vue emits events, LiveView handles them. The loop is complete.
            </p>
          </div>

          <div class="feature-card">
            <div class="feature-icon">🖥️</div>
            <h3 class="feature-title">Server-Side Rendered</h3>
            <p class="feature-desc">
              Vue components render on first paint. No loading flash. Full SEO.
            </p>
          </div>

          <div class="feature-card">
            <div class="feature-icon">📦</div>
            <h3 class="feature-title">Efficient Updates</h3>
            <p class="feature-desc">JSON patches over WebSocket. Only changed props are sent.</p>
          </div>

          <div class="feature-card">
            <div class="feature-icon">🚀</div>
            <h3 class="feature-title">One-Line Install</h3>
            <p class="feature-desc">
              Igniter handles the setup. TypeScript, Vite, SSR — all configured.
            </p>
          </div>

          <div class="feature-card">
            <div class="feature-icon">🎯</div>
            <h3 class="feature-title">Streams & Forms</h3>
            <p class="feature-desc">
              Phoenix Streams work transparently. Ecto changesets power validation.
            </p>
          </div>

          <div class="feature-card">
            <div class="feature-icon">📁</div>
            <h3 class="feature-title">File Uploads</h3>
            <p class="feature-desc">
              useLiveUpload() wraps LiveView's upload system with a Vue-friendly API.
            </p>
          </div>

          <div class="feature-card">
            <div class="feature-icon">🦄</div>
            <h3 class="feature-title">Vue Ecosystem</h3>
            <p class="feature-desc">
              Use any Vue library. Chart.js, TipTap, Headless UI — they all work.
            </p>
          </div>
        </div>
      </section>

      <%!-- INTERACTIVE DEMO SECTION --%>
      <section id="demo" class="demo-section">
        <div class="demo-container">
          <div class="demo-header">
            <span class="section-label">Try it live</span>
            <h2 class="section-title">Server state meets<br />client interactivity</h2>
          </div>

          <div class="demo-content">
            <div class="demo-vue-component">
              <.vue v-component="CounterDemo" count={@count} v-socket={@socket} />
            </div>

            <div class="demo-explanation">
              <div class="explanation-item">
                <div class="explanation-number">01</div>
                <div class="explanation-text">
                  <strong>The count lives on the server.</strong>
                  <span>LiveView owns {@count}. Vue receives it as a prop.</span>
                </div>
              </div>
              <div class="explanation-item">
                <div class="explanation-number">02</div>
                <div class="explanation-text">
                  <strong>The slider is local Vue state.</strong>
                  <span>No server round-trip for UI-only state.</span>
                </div>
              </div>
              <div class="explanation-item">
                <div class="explanation-number">03</div>
                <div class="explanation-text">
                  <strong>phx-click triggers handle_event.</strong>
                  <span>Vue template, LiveView handler. Seamless.</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      <%!-- CODE SECTION --%>
      <section id="code" class="code-section">
        <div class="code-container">
          <div class="code-header">
            <span class="section-label">The mental model</span>
            <h2 class="section-title">Props in. Events out.<br />Server owns the state.</h2>
          </div>

          <div class="code-panels">
            <div class="code-panel">
              <div class="code-panel-header">
                <span class="panel-dot dot-vue"></span>
                <span class="panel-label">Counter.vue</span>
                <span class="panel-badge">Vue Component</span>
              </div>
              <pre class="code-block"><code>{vue_code_example()}</code></pre>
            </div>

            <div class="code-panel">
              <div class="code-panel-header">
                <span class="panel-dot dot-elixir"></span>
                <span class="panel-label">counter_live.ex</span>
                <span class="panel-badge">LiveView</span>
              </div>
              <pre class="code-block"><code>{elixir_code_example()}</code></pre>
            </div>
          </div>

          <div class="code-flow-indicator">
            <div class="flow-line"></div>
            <div class="flow-labels">
              <span class="flow-label flow-label-props">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M12 5v14M5 12l7 7 7-7" />
                </svg>
                Props
              </span>
              <span class="flow-label flow-label-events">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <path d="M12 19V5M5 12l7-7 7 7" />
                </svg>
                Events
              </span>
            </div>
          </div>
        </div>
      </section>

      <%!-- USE CASES SECTION --%>
      <section class="usecases-section">
        <div class="usecases-container">
          <div class="usecase-column usecase-yes">
            <h3 class="usecase-heading">
              <span class="usecase-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3">
                  <path d="M5 13l4 4L19 7" />
                </svg>
              </span>
              When to use LiveVue
            </h3>
            <ul class="usecase-list">
              <li>Rich interactions - drag-drop, animations, complex local state</li>
              <li>Third-party libraries - Chart.js, TipTap, any Vue package</li>
              <li>Team familiarity - your team knows Vue</li>
              <li>Gradual adoption - start with one component</li>
            </ul>
          </div>
          <div class="usecase-divider"></div>
          <div class="usecase-column usecase-no">
            <h3 class="usecase-heading">
              <span class="usecase-icon">
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                  <circle cx="12" cy="12" r="8" />
                </svg>
              </span>
              When LiveView is enough
            </h3>
            <ul class="usecase-list">
              <li>Forms, tables, simple interactions</li>
              <li>Server-rendered content with minimal JS</li>
              <li>When you do not need the Vue runtime (around 34 KB gzipped)</li>
            </ul>
          </div>
        </div>
      </section>

      <%!-- FOOTER CTA --%>
      <section class="footer-cta-section">
        <div class="footer-cta-bg">
          <div class="gradient-orb orb-phoenix-sm"></div>
          <div class="gradient-orb orb-vue-sm"></div>
        </div>
        <div class="footer-cta-content">
          <h2 class="footer-cta-title">Ready to bridge the gap?</h2>
          <p class="footer-cta-desc">
            One command. Full TypeScript. SSR included. Start building.
          </p>
          <div class="footer-cta-install">
            <code>mix igniter.install live_vue</code>
          </div>
          <div class="footer-cta-links">
            <a href="https://hexdocs.pm/live_vue" class="cta-primary">
              Read the docs
              <svg
                class="cta-arrow"
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
              >
                <path d="M5 12h14M12 5l7 7-7 7" />
              </svg>
            </a>
            <a href="https://github.com/Valian/live_vue" class="cta-secondary">
              View on GitHub
            </a>
          </div>
        </div>
      </section>

      <%!-- FOOTER --%>
      <footer class="site-footer">
        <div class="footer-content">
          <div class="footer-brand">
            <span class="logo-phoenix">Live</span><span class="logo-vue">Vue</span>
          </div>
          <div class="footer-links">
            <a href="https://hexdocs.pm/live_vue">Documentation</a>
            <a href="https://github.com/Valian/live_vue">GitHub</a>
            <a href="https://hex.pm/packages/live_vue">Hex.pm</a>
          </div>
          <div class="footer-credit">
            Built with Phoenix LiveView + Vue.js
          </div>
        </div>
      </footer>
    </div>
    """
  end
end
