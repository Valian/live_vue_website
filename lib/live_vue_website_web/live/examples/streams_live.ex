defmodule LiveVueWebsiteWeb.Examples.StreamsLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("Streams")
  @elixir_source ExampleSource.elixir_source("Streams")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Phoenix Streams – LiveVue Examples",
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
    <Layouts.examples current_example="streams">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Phoenix Streams</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Phoenix Streams
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Efficiently manage large or dynamic collections with Phoenix streams.
          Perfect for chat messages, feeds, and real-time lists.
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
              <div class="font-medium text-landing-text text-sm">Phoenix Streams</div>
              <div class="text-xs text-landing-muted">stream() and stream_insert()</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Transparent Arrays</div>
              <div class="text-xs text-landing-muted">Streams become arrays in Vue</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Async Processing</div>
              <div class="text-xs text-landing-muted">start_async for background work</div>
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
              <div class="max-w-lg mx-auto">
                {live_render(@socket, LiveVueWebsiteWeb.Examples.StreamsPreview,
                  id: "streams-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="streams_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="Streams.vue"
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
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                1
              </span>
              Streams are transparently converted to arrays
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              When you pass
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">@streams.messages</code>
              to a Vue component, LiveVue automatically converts it to a regular JavaScript array.
              All the memory and performance benefits of streams still apply on the server side.
            </p>
            <.example_snippet code={
              ~s|<.vue messages={@streams.messages} v-component="Chat" v-socket={@socket} />|
            } />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                2
              </span>
              Initialize and update streams in LiveView
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">stream/3</code>
              in mount to initialize,
              and
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">stream_insert/3</code>
              to add items.
              Only the diff is sent over the wire, making updates very efficient.
            </p>
            <.example_snippet
              language="elixir"
              code="# Initialize
    |> stream(:messages, [])

    # Insert
    |> stream_insert(:messages, new_message)"
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                3
              </span>
              Use start_async for background work
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              When processing takes time (like AI responses), use
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">start_async/3</code>
              to run work in the background. This keeps the UI responsive and allows
              props to update during processing.
            </p>
            <.example_snippet
              language="elixir"
              code="socket
    |> assign(is_thinking: true)
    |> start_async(:ai_response, fn ->
    # Background work here
    generate_response()
    end)"
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                4
              </span>
              Handle async results
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              The <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">handle_async/3</code>
              callback receives the result when the background task completes.
              Update your assigns here to reflect the new state.
            </p>
            <.example_snippet
              language="elixir"
              code="def handle_async(:ai_response, {:ok, response}, socket) do
    {:noreply,
    socket
    |> stream_insert(:messages, response)
    |> assign(is_thinking: false)}
    end"
            />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: Connection Status
          </div>
          <.link navigate="/examples/connection-status" class="text-vue hover:underline text-sm">
            View example →
          </.link>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
