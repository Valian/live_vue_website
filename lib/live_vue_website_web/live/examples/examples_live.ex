defmodule LiveVueWebsiteWeb.ExamplesLive do
  use LiveVueWebsiteWeb, :live_view

  @examples [
    %{
      category: "Getting Started",
      items: [
        %{
          id: "counter",
          title: "Counter",
          description: "Server state + local Vue state with phx-click events",
          icon: "hero-plus-circle",
          status: :coming_soon
        },
        %{
          id: "animated-counter",
          title: "Animated Counter",
          description: "Vue transitions and animations with server state",
          icon: "hero-sparkles",
          status: :coming_soon
        }
      ]
    },
    %{
      category: "Events",
      items: [
        %{
          id: "events",
          title: "Event Handling",
          description: "pushEvent, phx-click, and useLiveVue()",
          icon: "hero-cursor-arrow-rays",
          status: :coming_soon
        },
        %{
          id: "server-events",
          title: "Server Events",
          description: "useLiveEvent() for server-pushed notifications",
          icon: "hero-bell-alert",
          status: :coming_soon
        }
      ]
    },
    %{
      category: "Navigation",
      items: [
        %{
          id: "navigation",
          title: "Navigation",
          description: "Link component with patch, navigate, href",
          icon: "hero-arrow-path",
          status: :coming_soon
        }
      ]
    },
    %{
      category: "Forms",
      items: [
        %{
          id: "simple-form",
          title: "Simple Form",
          description: "useLiveForm() with Ecto validation",
          icon: "hero-document-text",
          status: :coming_soon
        },
        %{
          id: "nested-form",
          title: "Nested Objects",
          description: "Nested fields with dot notation paths",
          icon: "hero-square-3-stack-3d",
          status: :coming_soon
        },
        %{
          id: "array-form",
          title: "Dynamic Arrays",
          description: "fieldArray() with add, remove, move",
          icon: "hero-queue-list",
          status: :coming_soon
        }
      ]
    },
    %{
      category: "Uploads",
      items: [
        %{
          id: "file-upload",
          title: "File Upload",
          description: "useLiveUpload() with progress tracking",
          icon: "hero-cloud-arrow-up",
          status: :coming_soon
        }
      ]
    },
    %{
      category: "Real-time",
      items: [
        %{
          id: "streams",
          title: "Phoenix Streams",
          description: "Efficient list updates with stream()",
          icon: "hero-signal",
          status: :coming_soon
        },
        %{
          id: "connection-status",
          title: "Connection Status",
          description: "useLiveConnection() for offline handling",
          icon: "hero-wifi",
          status: :coming_soon
        }
      ]
    },
    %{
      category: "Advanced",
      items: [
        %{
          id: "slots",
          title: "Slots",
          description: "Default and named slots with HEEX content",
          icon: "hero-puzzle-piece",
          status: :coming_soon
        },
        %{
          id: "ssr-control",
          title: "SSR Control",
          description: "Disable SSR for client-only components",
          icon: "hero-server",
          status: :coming_soon
        }
      ]
    }
  ]

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Examples – LiveVue",
       examples: @examples
     )}
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
              <h2 class="font-serif text-sm uppercase tracking-[0.2em] text-landing-muted">
                Examples
              </h2>
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
                            "text-landing-muted hover:text-landing-text hover:bg-white/5",
                            item.status == :coming_soon && "opacity-50 pointer-events-none"
                          ]}
                        >
                          <span class={[
                            "w-6 h-6 flex items-center justify-center rounded-md",
                            "bg-landing-elevated text-landing-muted"
                          ]}>
                            <.icon name={item.icon} class="w-3.5 h-3.5" />
                          </span>
                          <span class="flex-1">{item.title}</span>
                          <%= if item.status == :coming_soon do %>
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
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
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
            <header class="mb-12">
              <div class="inline-flex items-center gap-2 py-1.5 px-4 bg-white/5 border border-landing-border rounded-full text-xs text-landing-muted mb-6">
                <span class="w-1.5 h-1.5 bg-vue rounded-full animate-[pulse-dot_2s_ease-in-out_infinite]">
                </span>
                Interactive Examples
              </div>
              <h1 class="font-serif text-[clamp(2.5rem,5vw,3.5rem)] font-normal leading-tight tracking-tight mb-4">
                Learn by <span class="text-phoenix italic">doing</span>
              </h1>
              <p class="text-lg text-landing-muted max-w-2xl leading-relaxed">
                Each example shows a complete, working implementation with both LiveView and Vue source code.
                See how props flow from server to client, and how events bubble back up.
              </p>
            </header>

            <%!-- How examples work --%>
            <section class="mb-16 p-8 bg-landing-card/50 border border-landing-border rounded-xl">
              <h2 class="font-serif text-xl mb-6 tracking-tight">How these examples work</h2>
              <div class="grid grid-cols-3 gap-6 max-sm:grid-cols-1">
                <div class="flex gap-4">
                  <div class="shrink-0 w-8 h-8 flex items-center justify-center rounded-lg bg-phoenix/10 text-phoenix font-mono text-sm font-semibold">
                    1
                  </div>
                  <div>
                    <h3 class="font-medium text-landing-text mb-1">Preview</h3>
                    <p class="text-sm text-landing-muted leading-relaxed">
                      Interact with the live component. State updates flow through the WebSocket.
                    </p>
                  </div>
                </div>
                <div class="flex gap-4">
                  <div class="shrink-0 w-8 h-8 flex items-center justify-center rounded-lg bg-phoenix/10 text-phoenix font-mono text-sm font-semibold">
                    2
                  </div>
                  <div>
                    <h3 class="font-medium text-landing-text mb-1">LiveView</h3>
                    <p class="text-sm text-landing-muted leading-relaxed">
                      The Elixir code that manages state and handles events server-side.
                    </p>
                  </div>
                </div>
                <div class="flex gap-4">
                  <div class="shrink-0 w-8 h-8 flex items-center justify-center rounded-lg bg-vue/10 text-vue font-mono text-sm font-semibold">
                    3
                  </div>
                  <div>
                    <h3 class="font-medium text-landing-text mb-1">Vue</h3>
                    <p class="text-sm text-landing-muted leading-relaxed">
                      The Vue component that receives props and provides the UI.
                    </p>
                  </div>
                </div>
              </div>
            </section>

            <%!-- Example Grid --%>
            <section>
              <h2 class="font-serif text-2xl mb-8 tracking-tight">All Examples</h2>
              <div class="space-y-8">
                <%= for category <- @examples do %>
                  <div>
                    <h3 class="text-sm font-medium uppercase tracking-wider text-landing-muted mb-4">
                      {category.category}
                    </h3>
                    <div class="grid grid-cols-2 gap-4 max-sm:grid-cols-1">
                      <%= for item <- category.items do %>
                        <.link
                          navigate={"/examples/#{item.id}"}
                          class={[
                            "group relative p-6 bg-landing-card border border-landing-border rounded-xl transition-all duration-300",
                            if(item.status != :coming_soon,
                              do: "hover:-translate-y-1 hover:border-landing-muted hover:shadow-lg hover:shadow-black/20",
                              else: "opacity-50 cursor-not-allowed"
                            )
                          ]}
                        >
                          <div class="flex items-start gap-4">
                            <div class={[
                              "w-10 h-10 flex items-center justify-center rounded-lg transition-colors",
                              "bg-landing-elevated group-hover:bg-phoenix/10 text-landing-muted group-hover:text-phoenix"
                            ]}>
                              <.icon name={item.icon} class="w-5 h-5" />
                            </div>
                            <div class="flex-1 min-w-0">
                              <h4 class="font-medium text-landing-text mb-1 flex items-center gap-2">
                                {item.title}
                                <%= if item.status == :coming_soon do %>
                                  <span class="text-[10px] uppercase tracking-wider text-landing-muted/70 bg-landing-elevated px-1.5 py-0.5 rounded">
                                    Coming Soon
                                  </span>
                                <% end %>
                              </h4>
                              <p class="text-sm text-landing-muted leading-relaxed">
                                {item.description}
                              </p>
                            </div>
                            <%= if item.status != :coming_soon do %>
                              <svg
                                viewBox="0 0 24 24"
                                fill="none"
                                stroke="currentColor"
                                stroke-width="2"
                                class="w-5 h-5 text-landing-muted opacity-0 -translate-x-2 transition-all group-hover:opacity-100 group-hover:translate-x-0"
                              >
                                <path d="M5 12h14M12 5l7 7-7 7" />
                              </svg>
                            <% end %>
                          </div>
                        </.link>
                      <% end %>
                    </div>
                  </div>
                <% end %>
              </div>
            </section>

            <%!-- CTA --%>
            <section class="mt-16 p-8 bg-gradient-to-br from-phoenix/5 to-vue/5 border border-landing-border rounded-xl text-center">
              <h2 class="font-serif text-2xl mb-3 tracking-tight">Ready to build?</h2>
              <p class="text-landing-muted mb-6">
                Install LiveVue and start using Vue components in your Phoenix app.
              </p>
              <div class="inline-block py-3 px-6 bg-landing-elevated border border-landing-border rounded-lg font-mono text-sm text-vue mb-4">
                mix igniter.install live_vue
              </div>
              <div class="flex gap-4 justify-center">
                <a
                  href="https://hexdocs.pm/live_vue"
                  class="inline-flex items-center gap-2 py-2.5 px-5 bg-gradient-to-br from-phoenix to-phoenix-glow text-white text-sm font-medium rounded-lg transition-all duration-200 shadow-lg shadow-phoenix/20 hover:-translate-y-0.5 hover:shadow-xl hover:shadow-phoenix/30"
                >
                  Read the docs
                  <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
                    <path d="M5 12h14M12 5l7 7-7 7" />
                  </svg>
                </a>
              </div>
            </section>
          </div>
        </main>
      </div>
    </div>
    """
  end
end
