defmodule LiveVueWebsiteWeb.Examples.SlotsPreview do
  @moduledoc """
  Minimal slots demo LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="space-y-6">
      <%!-- Example 1: Default slot only --%>
      <.vue v-component="examples/Slots" v-socket={@socket}>
        <p class="text-landing-text">
          This is content in the <strong class="text-vue">default slot</strong>.
          No header or footer, just the main content area.
        </p>
      </.vue>

      <%!-- Example 2: Header + default --%>
      <.vue v-component="examples/Slots" variant="primary" v-socket={@socket}>
        <:icon>
          <.icon name="hero-information-circle" class="w-5 h-5" />
        </:icon>
        <:header>
          <h3 class="font-medium text-lg text-landing-text">Card with Header & Icon</h3>
        </:header>
        <p class="text-landing-muted">
          This card demonstrates the header slot with an icon.
          The icon slot is positioned before the header text.
        </p>
      </.vue>

      <%!-- Example 3: All slots --%>
      <.vue v-component="examples/Slots" variant="success" v-socket={@socket}>
        <:icon>
          <.icon name="hero-check-circle" class="w-5 h-5" />
        </:icon>
        <:header>
          <div>
            <h3 class="font-medium text-lg text-landing-text">Full Card Example</h3>
            <p class="text-sm text-landing-muted mt-1">With header, content, and footer slots</p>
          </div>
        </:header>
        <:footer>
          <div class="flex justify-between items-center">
            <span class="text-sm text-landing-muted">Updated 2 minutes ago</span>
            <button class="text-vue hover:underline text-sm font-medium">
              Learn more →
            </button>
          </div>
        </:footer>
        <p class="text-landing-text mb-3">
          This demonstrates all available slots working together.
          Each slot can contain any HEEx content, including components.
        </p>
        <ul class="list-disc list-inside text-landing-muted space-y-1 text-sm">
          <li>Icon slot appears in the header</li>
          <li>Header slot contains a title and subtitle</li>
          <li>Default slot holds the main content</li>
          <li>Footer slot provides actions</li>
        </ul>
      </.vue>

      <%!-- Example 4: Using title prop with fallback --%>
      <.vue v-component="examples/Slots" title="Using Prop Fallback" v-socket={@socket}>
        <p class="text-landing-muted">
          When no header slot is provided, the
          <code class="text-phoenix bg-phoenix/10 px-1.5 py-0.5 rounded text-sm">title</code>
          prop
          is used as fallback content. This is a common pattern for flexible components.
        </p>
      </.vue>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket, layout: false}
  end
end
