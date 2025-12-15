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
1. **Getting Started** - Counter
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

## Implementation Status

### Implemented (status: :ready)

| Example | Route | LiveVue Features | Files |
|---------|-------|------------------|-------|
| **Counter** | `/examples/counter` | Props, phx-click, local Vue state, `<Transition>` | `counter_live.ex`, `counter_preview.ex`, `Counter.vue` |
| **Event Handling** | `/examples/events` | `pushEvent()`, `useLiveVue()`, `$live` template access | `events_live.ex`, `events_preview.ex`, `Events.vue` |
| **Server Events** | `/examples/server-events` | `push_event/3` (server), `useLiveEvent()` (client) | `server_events_live.ex`, `server_events_preview.ex`, `ServerEvents.vue` |
| **Navigation** | `/examples/navigation` | `Link` component (href/navigate/patch), `useLiveNavigation()` | `navigation_live.ex`, `navigation_preview.ex`, `Navigation.vue` |
| **SSR Control** | `/examples/ssr-control` | `v-ssr={false}`, `onMounted()` for client detection | `ssr_control_live.ex`, `ssr_control_preview.ex`, `SsrControl.vue` |
| **Connection Status** | `/examples/connection-status` | `useLiveConnection()`, WebSocket state tracking | `connection_status_live.ex`, `connection_status_preview.ex`, `ConnectionStatus.vue` |
| **Slots** | `/examples/slots` | Default/named slots, HEEx content in Vue | `slots_live.ex`, `slots_preview.ex`, `Slots.vue` |

### Not Yet Implemented (status: :coming_soon)

| Example | Category | LiveVue Features | Complexity |
|---------|----------|------------------|------------|
| **Simple Form** | Forms | `useLiveForm()`, Ecto validation | Medium |
| **Nested Objects** | Forms | Nested field paths (dot notation) | Medium |
| **Dynamic Arrays** | Forms | `fieldArray()` with add/remove/move | Medium-High |
| **File Upload** | Uploads | `useLiveUpload()`, progress, drag & drop | Medium |
| **Phoenix Streams** | Real-time | `stream()` integration | Medium |

### Suggested Next Examples (by complexity)

**Medium complexity:**
1. **Simple Form** - `useLiveForm()` with basic Ecto changeset
2. **File Upload** - `useLiveUpload()` with `allow_upload` on server

**Higher complexity:**
3. **Phoenix Streams** - Requires understanding of LiveView streams
4. **Dynamic Arrays** - `fieldArray()` with complex form state

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

## Implementation Notes

### Key Patterns Discovered

**Child LiveView limitations:**
- Preview components are rendered via `live_render/3` as child LiveViews
- Child LiveViews **cannot** use `handle_params/3` - only root LiveViews receive URL params
- For previews that need URL-like state, use `handle_event` with client-side callbacks instead

**Props naming:**
- Props passed from Elixir use snake_case (e.g., `notification_count`)
- `LiveVue.Test.get_vue/2` returns props with snake_case keys
- Vue components receive props as-is (no automatic camelCase conversion)

**Testing patterns:**
- Use `LiveVue.Test.get_vue(view, name: "examples/ComponentName")` to inspect Vue props
- For child LiveViews, use `find_live_child(view, "preview-id")` then `render_hook`
- HTML content assertions work for SSR-rendered content

### Reference Files

When implementing a new example, use these as templates:
- **Simple example:** `counter_live.ex`, `counter_preview.ex`, `Counter.vue`
- **With server events:** `server_events_live.ex`, `server_events_preview.ex`, `ServerEvents.vue`
- **With client hooks:** `navigation_live.ex`, `navigation_preview.ex`, `Navigation.vue`

### LiveVue Source Reference

Full LiveVue source code is available at `deps/live_vue/` including:
- `lib/live_vue.ex` - Main module, `vue` component
- `assets/js/live_vue/` - JavaScript composables (`useLiveVue`, `useLiveEvent`, etc.)
- `lib/live_vue/test.ex` - Test helpers
