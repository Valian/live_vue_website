defmodule LiveVueWebsiteWeb.Examples.NavigationLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("Navigation")
  @elixir_source ExampleSource.elixir_source("Navigation")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Navigation – LiveVue Examples",
       vue_source: @vue_source,
       elixir_source: @elixir_source
     )}
  end

  def handle_params(params, uri, socket) do
    tab = if params["tab"] in @valid_tabs, do: params["tab"], else: "preview"
    %URI{path: path} = URI.parse(uri)

    {:noreply,
     assign(socket,
       active_tab: tab,
       current_path: path,
       query_params: Map.drop(params, ["tab"])
     )}
  end

  def render(assigns) do
    ~H"""
    <Layouts.examples current_example="navigation">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Navigation</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Navigation
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          LiveView-aware navigation with the
          <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">Link</code>
          component and
          <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveNavigation()</code>
          hook. Choose between full page loads, LiveView navigation, or patching with query params.
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
              <div class="font-medium text-landing-text text-sm">Link Component</div>
              <div class="text-xs text-landing-muted">href, navigate, patch</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">useLiveNavigation()</div>
              <div class="text-xs text-landing-muted">Programmatic navigation</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Query Params</div>
              <div class="text-xs text-landing-muted">Patching with replace</div>
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
              <div class="w-full max-w-2xl">
                <.vue
                  current_path={@current_path}
                  query_params={@query_params}
                  v-component="examples/Navigation"
                  v-socket={@socket}
                />
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="navigation_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="Navigation.vue"
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
              Link component for declarative navigation
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">Link</code>
              component provides three navigation modes:
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">href</code>
              for normal links, <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">navigate</code>
              for LiveView navigation with new state, and
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">patch</code>
              for updating params while preserving state.
            </p>
            <.example_snippet
              language="vue"
              code={~s|<Link navigate="/users">Users</Link>|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              useLiveNavigation() for programmatic control
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              When you need to navigate based on logic or user actions, use the
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveNavigation()</code>
              composable. It provides
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">navigate()</code>
              and <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">patch()</code>
              functions.
            </p>
            <.example_snippet
              language="javascript"
              code="const { navigate, patch } = useLiveNavigation()"
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              Patch with query params and replace
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">patch()</code>
              to update query parameters without adding a history entry. Pass an object of params and options like
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">replace: true</code>
              to avoid cluttering the browser history.
            </p>
            <.example_snippet
              language="javascript"
              code={~s|patch({ tab: 'profile' }, { replace: true })|}
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                4
              </span>
              handle_params tracks navigation changes
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              LiveView's
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">handle_params</code>
              callback fires whenever the URL changes. Use it to update assigns based on the new path and query params,
              which then flow down as props to your Vue components.
            </p>
            <.example_snippet code={~s|def handle_params(params, uri, socket)|} />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: Simple Form with useLiveForm()
          </div>
          <span class="text-landing-muted/50 text-sm">Coming soon</span>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
