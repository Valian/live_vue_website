defmodule LiveVueWebsiteWeb.Examples.EncoderLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("Encoder")
  @elixir_source ExampleSource.elixir_source("Encoder")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Encoder – LiveVue Examples",
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
    <Layouts.examples current_example="encoder">
      <%!-- Header --%>
      <header class="mb-8">
        <div class="flex items-center gap-2 text-sm text-landing-muted mb-4">
          <a href="/examples" class="hover:text-landing-text transition-colors">Examples</a>
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" class="w-4 h-4">
            <path d="M9 18l6-6-6-6" />
          </svg>
          <span class="text-landing-text">Custom Encoder</span>
        </div>
        <h1 class="font-serif text-4xl font-normal tracking-tight mb-4">
          Custom Encoder
        </h1>
        <p class="text-lg text-landing-muted max-w-2xl">
          Control how structs are encoded to JSON using the
          <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">LiveVue.Encoder</code>
          protocol. Derive for simple cases, implement custom logic when needed.
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
              <div class="font-medium text-landing-text text-sm">@derive</div>
              <div class="text-xs text-landing-muted">Simple encoder derivation</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono font-bold">
              2
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">defimpl</div>
              <div class="text-xs text-landing-muted">Custom encode function</div>
            </div>
          </div>
          <div class="flex gap-3">
            <div class="shrink-0 w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono font-bold">
              3
            </div>
            <div>
              <div class="font-medium text-landing-text text-sm">Options</div>
              <div class="text-xs text-landing-muted">Runtime encoding behavior</div>
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
              <div class="w-full max-w-md">
                {live_render(@socket, LiveVueWebsiteWeb.Examples.EncoderPreview,
                  id: "encoder-preview"
                )}
              </div>
            </div>
          <% "liveview" -> %>
            <.example_code
              id="code-tab-liveview"
              code={@elixir_source}
              language="elixir"
              filename="encoder_live.ex"
              color="phoenix"
            />
          <% "vue" -> %>
            <.example_code
              id="code-tab-vue"
              code={@vue_source}
              language="vue"
              filename="Encoder.vue"
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
              Derive for simple structs
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Use
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">
                @derive LiveVue.Encoder
              </code>
              to automatically encode all struct fields. Add
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">only:</code>
              or <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">except:</code>
              to control which fields are included.
            </p>
            <.example_snippet
              language="elixir"
              code="defmodule Business do\n  @derive LiveVue.Encoder\n  defstruct [:name, :industry]\nend"
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                2
              </span>
              Custom implementations with options
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Implement the protocol directly when you need custom encoding logic. The
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">opts</code>
              parameter lets you change behavior at runtime.
            </p>
            <.example_snippet
              language="elixir"
              code="defimpl LiveVue.Encoder, for: UserProfile do\n  def encode(profile, opts) do\n    avatar_url =\n      if Keyword.get(opts, :avatar) == :original,\n        do: profile.avatar_original_url,\n        else: profile.avatar_url\n\n    %{\n      name: profile.name,\n      avatar_url: avatar_url,\n      business: encode(profile.business, opts)\n    }\n  end\nend"
            />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-vue/10 text-vue text-xs font-mono">
                3
              </span>
              Pass options when encoding
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              Call
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">
                LiveVue.Encoder.encode/2
              </code>
              explicitly in your template to pass custom options. This lets you control
              encoding per-prop.
            </p>
            <.example_snippet code={
              ~s'<.vue\n  profile={@profile}\n  profile_with_original_avatar={LiveVue.Encoder.encode(@profile, avatar: :original)}\n  v-component="UserProfile"\n  v-socket={@socket}\n/>'
            } />
          </div>

          <div class="p-6 bg-landing-card/50 border border-landing-border rounded-xl overflow-hidden">
            <h3 class="flex items-center gap-2 font-medium mb-3">
              <span class="w-6 h-6 flex items-center justify-center rounded bg-phoenix/10 text-phoenix text-xs font-mono">
                4
              </span>
              Nested structs are encoded recursively
            </h3>
            <p class="text-landing-muted text-sm leading-relaxed mb-3">
              When encoding nested structs, call
              <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded">
                LiveVue.Encoder.encode/2
              </code>
              on nested values to ensure they're properly encoded. Options are passed through.
            </p>
            <.example_snippet
              language="elixir"
              code="business: LiveVue.Encoder.encode(profile.business, opts)"
            />
          </div>
        </div>
      </section>

      <%!-- Next example --%>
      <section class="mt-12 pt-8 border-t border-landing-border">
        <div class="flex items-center justify-between">
          <div class="text-landing-muted text-sm">
            Next up: File Upload
          </div>
          <.link navigate="/examples/file-upload" class="text-vue hover:underline text-sm">
            View example →
          </.link>
        </div>
      </section>
    </Layouts.examples>
    """
  end
end
