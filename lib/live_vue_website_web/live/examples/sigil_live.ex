defmodule LiveVueWebsiteWeb.Examples.SigilLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @elixir_source ExampleSource.elixir_source("Sigil")

  # Stored as module attribute to avoid heredoc indentation warnings in template
  @sigil_snippet """
  def render(assigns) do
    ~VUE\"\"\"
    <script setup lang="ts">
    const props = defineProps<{ count: number }>()
    </script>

    <template>
      <div>{{ props.count }}</div>
    </template>
    \"\"\"
  end
  """

  @valid_tabs ~w(preview liveview)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Vue Sigil – LiveVue Examples",
       elixir_source: @elixir_source,
       sigil_snippet: @sigil_snippet
     )}
  end

  def handle_params(params, _uri, socket) do
    tab = if params["tab"] in @valid_tabs, do: params["tab"], else: "preview"
    {:noreply, assign(socket, :active_tab, tab)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.examples current_example="vue-sigil">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Vue Sigil</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Vue Sigil
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Write Vue components directly in your LiveView with the
          <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">~VUE</code>
          sigil. No separate file needed.
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
              <div class="font-medium text-landing-text text-sm">Single File</div>
              <div class="text-xs text-landing-muted">Vue + Elixir in one place</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Full Vue Power</div>
              <div class="text-xs text-landing-muted">script setup, TypeScript</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Rapid Prototyping</div>
              <div class="text-xs text-landing-muted">Quick iterations</div>
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
              <span class="w-2 h-2 rounded-full bg-gradient-to-r from-phoenix to-vue"></span>
              LiveView + Vue
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
                {live_render(@socket, LiveVueWebsiteWeb.Examples.SigilPreview, id: "sigil-preview")}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="sigil_live.ex"
              color="phoenix"
            />
        <% end %>
      </div>

      <%!-- VS Code extension callout --%>
      <section class="mt-8 p-6 bg-gradient-to-br from-vue/5 to-phoenix/5 border border-landing-border rounded-xl">
        <div class="flex items-start gap-4">
          <div class="shrink-0 w-10 h-10 flex items-center justify-center rounded-lg bg-vue/10 text-vue">
            <.icon name="hero-code-bracket" class="w-5 h-5" />
          </div>
          <div>
            <h3 class="font-medium text-landing-text mb-2">VS Code Extension</h3>
            <p class="text-sm text-landing-muted mb-3">
              Get syntax highlighting for the
              <code class="text-vue bg-vue/10 px-1 py-0.5 rounded">~VUE</code>
              sigil in VS Code with the community extension.
            </p>
            <a
              href="https://github.com/GuilhermePSF/live-vue-sigil-highlighting/releases"
              target="_blank"
              rel="noopener noreferrer"
              class="inline-flex items-center gap-2 text-sm text-vue hover:underline"
            >
              Get the extension
              <svg
                viewBox="0 0 24 24"
                fill="none"
                stroke="currentColor"
                stroke-width="2"
                class="w-4 h-4"
              >
                <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6" />
                <polyline points="15 3 21 3 21 9" />
                <line x1="10" y1="14" x2="21" y2="3" />
              </svg>
            </a>
          </div>
        </div>
      </section>

      <%!-- Explanation --%>
      <section class="mt-8 space-y-6">
        <h2 class="font-serif text-2xl tracking-tight">How it works</h2>

        <div class="grid gap-4">
          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                1
              </span>
              Write Vue inline
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Replace <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">~H</code>
              with <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">~VUE</code>
              and write a standard Vue SFC. Props are passed automatically from socket assigns.
            </p>
            <.example_snippet language="elixir" code={@sigil_snippet} />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                2
              </span>
              Phoenix bindings work
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">phx-click</code>, <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">phx-submit</code>,
              and other Phoenix bindings directly in the Vue template.
            </p>
            <.example_snippet
              language="vue"
              code={~s|<button phx-click="vote">Vote!</button>|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              Current limitations
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed">
              The <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">~VUE</code>
              sigil doesn't yet support TypeScript type-checking or autocomplete inside the sigil.
              There's ongoing work to bring full editor support. For now, use
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">.vue</code>
              files when you need rich editor tooling.
            </p>
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                4
              </span>
              When to use the sigil
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed">
              The <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">~VUE</code>
              sigil is perfect for
              small, self-contained components and rapid prototyping. For larger components or
              when you need type safety, use separate
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">.vue</code>
              files.
            </p>
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Explore more examples
          </div>
          <.link navigate="/examples" class="text-vue hover:underline text-sm">
            View all examples
          </.link>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
