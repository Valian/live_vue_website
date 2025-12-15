# LiveVue Examples Page Design

## Overview

A dedicated Examples page showcasing LiveVue features with live, interactive demos and source code.

## Architecture Decisions

### 1. Code Display Strategy

**Compile-time file embedding via `ExampleSource` macros**

```elixir
require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

@vue_source ExampleSource.vue_source("Counter")
@elixir_source ExampleSource.elixir_source("Counter")
```

The `ExampleSource` module provides two macros:
- `vue_source(name)` - Reads `assets/vue/examples/{Name}.vue`
- `elixir_source(name)` - Reads `{snake_name}_preview.ex` and transforms it for display

The Elixir source transformation:
- Renames module from `LiveVueWebsiteWeb.Examples.{Name}Preview` → `MyAppWeb.{Name}Live`
- Replaces `LiveVueWebsiteWeb` → `MyAppWeb`
- Replaces `examples/{Name}` → `{Name}` in component paths
- Removes `@moduledoc` and `layout: false`

This ensures:
- Code is always in sync with actual implementation
- No runtime file reading overhead
- Automatic recompilation when example files change (via `@external_resource`)

### 2. Routing Structure

**Separate routes, each backed by a dedicated LiveView**

```
/examples              → Index with foreword + redirect to first example
/examples/counter      → Counter example (Getting Started)
/examples/events       → Events demo
/examples/forms        → Simple form with validation
/examples/uploads      → File upload
...etc
```

Each route is a separate LiveView module for:
- Direct linking and bookmarking
- Independent state management per example
- Clean separation of concerns

### 3. Styling Approach

**Practical but minimal**

- Use existing Tailwind classes from the project
- No external component libraries in examples (shows the real implementation)
- Styling visible in Vue code so users see the complete picture
- Match landing page aesthetic for consistency

### 4. UI Pattern

**Tabs: Preview / LiveView / Vue**

```
┌─────────────────────────────────────────────────────┐
│  [Preview]  [LiveView]  [Vue]                       │
├─────────────────────────────────────────────────────┤
│                                                     │
│   (Active tab content - live demo or code)          │
│                                                     │
└─────────────────────────────────────────────────────┘
```

- **Preview**: Live interactive component
- **LiveView**: Elixir source with syntax highlighting
- **Vue**: Vue component source with syntax highlighting
- Copy button on code tabs
- Tab state persisted in URL query string (`?tab=preview|liveview|vue`)
- Tabs implemented as `<.link patch="?tab=...">` for shareable URLs and browser history support

### 5. Navigation

**Side navigation with categories**

Categories:
1. **Getting Started** - Counter, Animated Counter
2. **Events** - Phoenix events, Vue events, Server events
3. **Navigation** - Link component, programmatic navigation
4. **Forms** - Simple form, nested objects, dynamic arrays
5. **Uploads** - Basic upload, drag & drop
6. **Real-time** - Phoenix Streams, connection status
7. **Advanced** - Custom structs, SSR control, slots

### 6. Index Page

`/examples` shows:
- Brief foreword explaining how examples are structured
- Visual grid/list of all examples with descriptions
- Or redirects to first example (TBD)

## Example Priority

### Phase 1 (MVP)
1. Counter with transitions
2. Events demo (pushEvent, phx-click)
3. Simple form with validation
4. Basic file upload

### Phase 2
5. Navigation demo
6. Phoenix Streams
7. Server events (useLiveEvent)
8. Dynamic array form

### Phase 3
9. Complex nested form
10. Custom struct encoding
11. Connection status
12. Slots demo

## File Structure

```
lib/live_vue_website_web/live/examples/
  example_source.ex         # Macros for reading/transforming source code
  examples_live.ex          # Index page
  counter_live.ex           # Counter example page (full UI)
  counter_preview.ex        # Counter preview (minimal, shown in Preview tab)
  events_live.ex            # Events example page
  events_preview.ex         # Events preview
  ...

assets/vue/examples/
  Counter.vue
  EventsDemo.vue
  SimpleForm.vue
  FileUpload.vue
  ...
```

## Naming Conventions

Each example consists of two LiveView modules:

| Module | Purpose | Naming |
|--------|---------|--------|
| `{Name}Live` | Full example page with tabs, explanation, navigation | `{snake_name}_live.ex` |
| `{Name}Preview` | Minimal working demo, source displayed as example code | `{snake_name}_preview.ex` |

The Preview module:
- Should be minimal and self-contained
- Uses `layout: false` (stripped from displayed source)
- Has a `@moduledoc` explaining its purpose (stripped from displayed source)
- Component path uses `examples/{Name}` (transformed to just `{Name}` in display)

## Example Page Structure

Each `{Name}Live` module follows this template:

```elixir
defmodule LiveVueWebsiteWeb.Examples.{Name}Live do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("{Name}")
  @elixir_source ExampleSource.elixir_source("{Name}")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "{Name} – LiveVue Examples",
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
    <Layouts.examples current_example="{slug}">
      <%!-- Header with breadcrumb --%>
      <header class="mb-8">...</header>

      <%!-- Key concepts section --%>
      <section class="mb-8 p-6 bg-landing-card/50 ...">...</section>

      <%!-- Tabs: Preview / LiveView / Vue --%>
      <div class="mb-6">...</div>

      <%!-- Tab content --%>
      <div class="bg-landing-card border ...">
        <%= case @active_tab do %>
          <% "preview" -> %>
            {live_render(@socket, LiveVueWebsiteWeb.Examples.{Name}Preview, id: "{slug}-preview")}
          <% "liveview" -> %>
            <.example_code code={@elixir_source} language="elixir" filename="{slug}_live.ex" color="phoenix" />
          <% "vue" -> %>
            <.example_code code={@vue_source} language="vue" filename="{Name}.vue" color="vue" />
        <% end %>
      </div>

      <%!-- How it works explanation --%>
      <section class="mt-8 space-y-6">...</section>

      <%!-- Next example link --%>
      <section class="mt-12 pt-8 border-t ...">...</section>
    </Layouts.examples>
    """
  end
end
```

## Component Reuse

Shared components (defined in `core_components.ex` or `layouts.ex`):
- `Layouts.examples` - Side nav + content area layout
- `.example_code` - Syntax highlighted code block with filename header
- `.example_snippet` - Inline code snippet for explanations
