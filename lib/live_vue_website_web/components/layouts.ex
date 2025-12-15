defmodule LiveVueWebsiteWeb.Layouts do
  @moduledoc """
  This module holds layouts and related functionality
  used by your application.
  """
  use LiveVueWebsiteWeb, :html

  alias LiveVueWebsite.GitHubStars

  # Embed all files in layouts/* within this module.
  # The default root.html.heex file contains the HTML
  # skeleton of your application, namely HTML headers
  # and other static content.
  embed_templates "layouts/*"

  @doc """
  Renders your app layout.

  This function is typically invoked from every template,
  and it often contains your application menu, sidebar,
  or similar.

  ## Examples

      <Layouts.app flash={@flash}>
        <h1>Content</h1>
      </Layouts.app>

  """
  attr :flash, :map, required: true, doc: "the map of flash messages"

  attr :current_scope, :map,
    default: nil,
    doc: "the current [scope](https://hexdocs.pm/phoenix/scopes.html)"

  slot :inner_block, required: true

  def app(assigns) do
    ~H"""
    <header class="navbar sticky top-0 z-50 border-b border-base-300 bg-base-100/80 backdrop-blur px-4 sm:px-6 lg:px-8">
      <div class="flex-1">
        <a href="/" class="flex items-center gap-2 text-lg font-semibold">
          <span class="text-phoenix">Live</span><span class="text-vue">Vue</span>
        </a>
      </div>
      <div class="flex-none">
        <ul class="hidden sm:flex flex-row px-1 space-x-2 items-center">
          <li>
            <a href="#examples" class="btn btn-ghost btn-sm">Examples</a>
          </li>
          <li>
            <a href="https://hexdocs.pm/live_vue" class="btn btn-ghost btn-sm">Docs</a>
          </li>
          <li>
            <a href="https://github.com/Valian/live_vue" class="btn btn-ghost btn-sm">GitHub</a>
          </li>
          <li>
            <.theme_toggle />
          </li>
          <li>
            <a href="https://hexdocs.pm/live_vue" class="btn btn-primary btn-sm">
              Get Started <span aria-hidden="true">&rarr;</span>
            </a>
          </li>
        </ul>
        <div class="sm:hidden flex items-center gap-2">
          <.theme_toggle />
          <div class="dropdown dropdown-end">
            <div tabindex="0" role="button" class="btn btn-ghost btn-sm">
              <.icon name="hero-bars-3" class="size-5" />
            </div>
            <ul
              tabindex="0"
              class="dropdown-content menu bg-base-100 rounded-box z-50 w-52 p-2 shadow border border-base-300"
            >
              <li><a href="#examples">Examples</a></li>
              <li><a href="https://hexdocs.pm/live_vue">Docs</a></li>
              <li><a href="https://github.com/Valian/live_vue">GitHub</a></li>
            </ul>
          </div>
        </div>
      </div>
    </header>

    <main>
      {render_slot(@inner_block)}
    </main>

    <.flash_group flash={@flash} />
    """
  end

  alias LiveVueWebsite.Examples

  @doc """
  Renders the examples layout with side navigation.

  ## Examples

      <Layouts.examples current_example="counter">
        Your example content here
      </Layouts.examples>

      <Layouts.examples current_example="index">
        Introduction page content
      </Layouts.examples>
  """
  attr :current_example, :string,
    required: true,
    doc: "the id of the current example for highlighting (use 'index' for the intro page)"

  slot :inner_block, required: true

  def examples(assigns) do
    assigns =
      assigns
      |> assign(:examples_nav, Examples.nav())
      |> assign(:active_examples, ["index" | Examples.active_ids()])

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
          <div class="sticky top-0 h-screen flex flex-col">
            <%!-- Logo/Back link (fixed at top) --%>
            <div class="shrink-0 px-4 pt-6 pb-4">
              <a
                href="/"
                class="flex items-center gap-3 px-3 py-2 -mx-1 rounded-lg transition-colors hover:bg-white/5 group"
              >
                <img src="/images/live_vue_logo_rounded.png" alt="LiveVue" class="h-8 w-8 rounded-md" />
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
            </div>

            <%!-- Scrollable examples section --%>
            <div class="flex-1 overflow-y-auto px-4">
              <%!-- Introduction link --%>
              <% is_intro_current = @current_example == "index" %>
              <div class="mb-6">
                <.link
                  navigate="/examples"
                  class={[
                    "flex items-center gap-3 px-3 py-2 rounded-lg text-sm transition-all",
                    if(is_intro_current,
                      do: "bg-white/10 text-landing-text",
                      else: "text-landing-muted hover:text-landing-text hover:bg-white/5"
                    )
                  ]}
                >
                  <span class={[
                    "w-6 h-6 flex items-center justify-center rounded-md",
                    if(is_intro_current,
                      do: "bg-phoenix/20 text-phoenix",
                      else: "bg-landing-elevated text-landing-muted"
                    )
                  ]}>
                    <.icon name="hero-book-open" class="w-3.5 h-3.5" />
                  </span>
                  <span class="flex-1">Introduction</span>
                </.link>
              </div>

              <%!-- Navigation items --%>
              <nav class="space-y-6 pb-4">
                <%= for category <- @examples_nav do %>
                  <div>
                    <h3 class="px-3 mb-2 text-[11px] font-medium uppercase tracking-wider text-landing-muted/70">
                      {category.category}
                    </h3>
                    <ul class="space-y-0.5">
                      <%= for item <- category.items do %>
                        <% is_active = item.id in @active_examples %>
                        <% is_current = item.id == @current_example %>
                        <li>
                          <.link
                            navigate={"/examples/#{item.id}"}
                            class={[
                              "flex items-center gap-3 px-3 py-2 rounded-lg text-sm transition-all",
                              if(is_current,
                                do: "bg-white/10 text-landing-text",
                                else:
                                  if(is_active,
                                    do: "text-landing-muted hover:text-landing-text hover:bg-white/5",
                                    else:
                                      "text-landing-muted hover:text-landing-text hover:bg-white/5 opacity-50 pointer-events-none"
                                  )
                              )
                            ]}
                          >
                            <span class={[
                              "w-6 h-6 flex items-center justify-center rounded-md",
                              if(is_current,
                                do: "bg-phoenix/20 text-phoenix",
                                else: "bg-landing-elevated text-landing-muted"
                              )
                            ]}>
                              <.icon name={item.icon} class="w-3.5 h-3.5" />
                            </span>
                            <span class="flex-1">{item.title}</span>
                            <%= if not is_active do %>
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
            </div>

            <%!-- Bottom links (fixed at bottom) --%>
            <div class="shrink-0 px-4 pb-6 pt-4 border-t border-landing-border/30">
              <div class="px-3 space-y-2">
                <a
                  href="https://hexdocs.pm/live_vue"
                  class="flex items-center gap-2 text-sm text-landing-muted hover:text-landing-text transition-colors"
                >
                  <svg
                    viewBox="0 0 24 24"
                    fill="none"
                    stroke="currentColor"
                    stroke-width="2"
                    class="w-4 h-4"
                  >
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
                  <span class="flex-1">GitHub</span>
                  <svg viewBox="0 0 24 24" fill="currentColor" class="w-3.5 h-3.5 text-amber-400">
                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
                  </svg>
                  <span class="font-mono text-xs">{GitHubStars.get_stars()}</span>
                </a>
              </div>
            </div>
          </div>
        </aside>

        <%!-- Main Content --%>
        <main class="flex-1 min-w-0">
          <div class="max-w-4xl mx-auto px-8 py-12">
            {render_slot(@inner_block)}
          </div>
        </main>
      </div>
    </div>
    """
  end

  @doc """
  Shows the flash group with standard titles and content.

  ## Examples

      <.flash_group flash={@flash} />
  """
  attr :flash, :map, required: true, doc: "the map of flash messages"
  attr :id, :string, default: "flash-group", doc: "the optional id of flash container"

  def flash_group(assigns) do
    ~H"""
    <div id={@id} aria-live="polite">
      <.flash kind={:info} flash={@flash} />
      <.flash kind={:error} flash={@flash} />

      <.flash
        id="client-error"
        kind={:error}
        title={gettext("We can't find the internet")}
        phx-disconnected={show(".phx-client-error #client-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#client-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>

      <.flash
        id="server-error"
        kind={:error}
        title={gettext("Something went wrong!")}
        phx-disconnected={show(".phx-server-error #server-error") |> JS.remove_attribute("hidden")}
        phx-connected={hide("#server-error") |> JS.set_attribute({"hidden", ""})}
        hidden
      >
        {gettext("Attempting to reconnect")}
        <.icon name="hero-arrow-path" class="ml-1 size-3 motion-safe:animate-spin" />
      </.flash>
    </div>
    """
  end

  @doc """
  Provides dark vs light theme toggle based on themes defined in app.css.

  See <head> in root.html.heex which applies the theme before page load.
  """
  def theme_toggle(assigns) do
    ~H"""
    <div class="card relative flex flex-row items-center border-2 border-base-300 bg-base-300 rounded-full">
      <div class="absolute w-1/3 h-full rounded-full border-1 border-base-200 bg-base-100 brightness-200 left-0 [[data-theme=light]_&]:left-1/3 [[data-theme=dark]_&]:left-2/3 transition-[left]" />

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="system"
      >
        <.icon name="hero-computer-desktop-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="light"
      >
        <.icon name="hero-sun-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>

      <button
        class="flex p-2 cursor-pointer w-1/3"
        phx-click={JS.dispatch("phx:set-theme")}
        data-phx-theme="dark"
      >
        <.icon name="hero-moon-micro" class="size-4 opacity-75 hover:opacity-100" />
      </button>
    </div>
    """
  end
end
