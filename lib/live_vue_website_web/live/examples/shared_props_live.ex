defmodule LiveVueWebsiteWeb.Examples.SharedPropsLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("SharedProps")
  @elixir_source ExampleSource.elixir_source("SharedProps")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Shared Props – LiveVue Examples",
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
    <Layouts.examples current_example="shared-props">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Shared Props</span>
        </div>
        <div class="flex items-center gap-3 mb-4">
          <h1 class="font-serif text-4xl font-normal tracking-tight">
            Headless Shared Props
          </h1>
          <span class="inline-flex items-center py-0.5 px-2 bg-vue/10 border border-vue/30 rounded-full text-xs font-mono text-vue">
            v1.1
          </span>
        </div>
        <p class="text-lg text-landing-muted max-w-2xl">
          Use a headless LiveVue component (no <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">v-component</code>)
          as a global state provider. Other components read shared props via <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveVue(id)</code>.
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
              <div class="font-medium text-landing-text text-sm">Headless Component</div>
              <div class="text-xs text-landing-muted">.vue with id but no v-component</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">useLiveVue(id)</div>
              <div class="text-xs text-landing-muted">Read shared props by id</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Reactive Updates</div>
              <div class="text-xs text-landing-muted">Server changes propagate to consumers</div>
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
            <div class="p-8">
              <div class="max-w-md mx-auto">
                {live_render(@socket, LiveVueWebsiteWeb.Examples.SharedPropsPreview,
                  id: "shared-props-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="shared_props_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="SharedProps.vue"
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
              Render a headless component with just an id
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              A <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">&lt;.vue&gt;</code>
              without
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">v-component</code>
              renders nothing visually but registers its props under the given id.
              In a real app, this lives in a sticky LiveView so it persists across page navigation.
            </p>
            <.example_snippet code={
              ~s|<.vue id="shared-state" v-socket={@socket} user={@user} theme={@theme} />|
            } />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                2
              </span>
              Read shared props with useLiveVue(id)
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Any Vue component on the page can call
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveVue("shared-state")</code>
              to access the headless component's props reactively. No prop drilling required.
            </p>
            <.example_snippet
              language="javascript"
              code={
                ~s|const shared = useLiveVue("shared-state")\nconst user = computed(() => shared?.vue.props.user)|
              }
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                3
              </span>
              Server changes propagate automatically
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed">
              When the server updates assigns on the headless component (e.g. switching user or theme),
              all consumers that read via
              <code class="text-vue bg-vue/10 px-1.5 py-0.5 rounded">useLiveVue()</code>
              re-render with the new values. Try toggling theme or switching users above.
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
