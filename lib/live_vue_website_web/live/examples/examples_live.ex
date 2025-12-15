defmodule LiveVueWebsiteWeb.ExamplesLive do
  use LiveVueWebsiteWeb, :live_view

  alias LiveVueWebsite.Examples

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Examples – LiveVue",
       examples: Examples.catalog()
     )}
  end

  def render(assigns) do
    ~H"""
    <Layouts.examples current_example="index">
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
                        do:
                          "hover:-translate-y-1 hover:border-landing-muted hover:shadow-lg hover:shadow-black/20",
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
            <svg
              viewBox="0 0 24 24"
              fill="none"
              stroke="currentColor"
              stroke-width="2"
              class="w-4 h-4"
            >
              <path d="M5 12h14M12 5l7 7-7 7" />
            </svg>
          </a>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
