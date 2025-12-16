# LiveVue Example Conventions

This document outlines conventions and approaches for creating new examples in the LiveVue website project. The source code for the `live_vue` library itself is in `deps/live_vue/`.

## File Structure Overview

```
lib/live_vue_website_web/live/examples/
  example_source.ex          # Macro utilities for code display
  examples_live.ex           # Index page listing all examples
  counter_live.ex            # Full example page with tabs
  counter_preview.ex         # Minimal working demo
  ...

assets/vue/examples/
  Counter.vue                # Vue component for counter example
  ...

lib/live_vue_website/
  examples.ex                # Example catalog with metadata

test/live_vue_website_web/live/examples/
  counter_live_test.exs      # Tests for counter example
  ...
```

## Two-File Pattern Per Example

Each example consists of two LiveView modules:

### 1. Preview Module (`*_preview.ex`)

A minimal working demo whose source code is displayed to users.

**Reference:** `lib/live_vue_website_web/live/examples/counter_preview.ex`

Key conventions:
- Module name: `LiveVueWebsiteWeb.Examples.{Name}Preview`
- Include `@moduledoc` describing the demo (removed in display)
- Use `layout: false` in mount (removed in display)
- Component path uses `examples/{Name}` (transformed to `{Name}` in display)
- Keep it minimal - this is what users see as example code

```elixir
defmodule LiveVueWebsiteWeb.Examples.CounterPreview do
  @moduledoc """
  Minimal counter LiveView for embedding in examples.
  The source of this module is displayed as example code.
  """
  use LiveVueWebsiteWeb, :live_view

  def render(assigns) do
    ~H"""
    <.vue
      count={@count}
      v-component="examples/Counter"
      v-socket={@socket}
    />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0), layout: false}
  end

  def handle_event("inc", %{"diff" => diff}, socket) do
    {:noreply, update(socket, :count, &(&1 + String.to_integer(diff)))}
  end
end
```

### 2. Full Example Page (`*_live.ex`)

The complete documentation page with tabs, explanations, and navigation.

**Reference:** `lib/live_vue_website_web/live/examples/counter_live.ex`

Key conventions:
- Module name: `LiveVueWebsiteWeb.Examples.{Name}Live`
- Use `ExampleSource` macros to embed source code at compile time
- Wrap content in `<Layouts.examples current_example="example-id">`
- Include header, key concepts, tabs, explanation, and next example link

```elixir
defmodule LiveVueWebsiteWeb.Examples.CounterLive do
  use LiveVueWebsiteWeb, :live_view

  require LiveVueWebsiteWeb.Examples.ExampleSource, as: ExampleSource

  @vue_source ExampleSource.vue_source("Counter")
  @elixir_source ExampleSource.elixir_source("Counter")

  @valid_tabs ~w(preview liveview vue)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       page_title: "Counter – LiveVue Examples",
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
    <Layouts.examples current_example="counter">
      <%!-- Header with breadcrumb --%>
      <%!-- Key concepts section --%>
      <%!-- Tab navigation --%>
      <%!-- Tab content (preview/liveview/vue) --%>
      <%!-- How it works explanation --%>
      <%!-- Next example link --%>
    </Layouts.examples>
    """
  end
end
```

## ExampleSource Macros

**Reference:** `lib/live_vue_website_web/live/examples/example_source.ex`

Two compile-time macros that read and transform source files:

### `ExampleSource.elixir_source("Name")`

Reads `{snake_name}_preview.ex` and applies transformations:
- Renames module from `LiveVueWebsiteWeb.Examples.NamePreview` to `MyAppWeb.NameLive`
- Replaces `LiveVueWebsiteWeb` with `MyAppWeb`
- Replaces `examples/Name` with `Name` in component paths
- Removes `@moduledoc`
- Removes `layout: false`

### `ExampleSource.vue_source("Name")`

Reads `assets/vue/examples/{Name}.vue` without transformation.

Both macros register files as `@external_resource` for hot-reload detection.

## Vue Component Conventions

**Reference:** `assets/vue/examples/Counter.vue`

- Use PascalCase filenames: `Counter.vue`, `SimpleForm.vue`
- Located in `assets/vue/examples/`
- Use `<script setup lang="ts">` syntax
- Define prop types with TypeScript: `defineProps<{ count: number }>()`
- Use LiveVue hooks: `useLiveVue()`, `useLiveForm()`, `useLiveEvent()`, etc.
- Use Tailwind classes with project color variables (`landing-*`, `phoenix`, `vue`)

```vue
<script setup lang="ts">
import { ref } from "vue"

const props = defineProps<{ count: number }>()
const diff = ref(1)
</script>

<template>
  <div class="p-6 rounded-xl border border-landing-border">
    <div class="text-5xl font-mono font-bold">{{ props.count }}</div>
    <button phx-click="inc" :phx-value-diff="diff">
      +{{ diff }}
    </button>
  </div>
</template>
```

## Example Catalog Registration

**Reference:** `lib/live_vue_website/examples.ex`

Add new examples to the catalog with metadata:

```elixir
%{
  id: "counter",              # URL slug (kebab-case)
  title: "Counter",           # Display title
  description: "Server state + local Vue state with phx-click events",
  icon: "hero-plus-circle",   # Heroicon name
  status: :ready              # :ready or :coming_soon
}
```

Categories:
- Getting Started
- Events
- Navigation
- Forms
- Uploads
- Real-time
- Advanced

## Router Registration

**Reference:** `lib/live_vue_website_web/router.ex`

```elixir
scope "/", LiveVueWebsiteWeb do
  pipe_through :browser

  live "/examples", ExamplesLive
  live "/examples/counter", Examples.CounterLive
  # ... more examples
end
```

URL format: `/examples/{kebab-case-id}` (e.g., `/examples/simple-form`)

## Testing Conventions

**Reference:** `test/live_vue_website_web/live/examples/counter_live_test.exs`

### File Structure

- Location: `test/live_vue_website_web/live/examples/{snake_name}_live_test.exs`
- Module: `LiveVueWebsiteWeb.Examples.{Name}LiveTest`

### Test Template

```elixir
defmodule LiveVueWebsiteWeb.Examples.CounterLiveTest do
  use LiveVueWebsiteWeb.ConnCase, async: true
  import Phoenix.LiveViewTest

  describe "{Name}Live page" do
    test "renders the {name} example page with preview tab by default", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/examples/{example-id}")

      assert html =~ "Example Title"
      assert has_element?(view, "a[href='?tab=preview']")
      assert has_element?(view, "a[href='?tab=liveview']")
      assert has_element?(view, "a[href='?tab=vue']")
    end

    test "can switch between tabs", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/{example-id}")

      view |> element("a[href='?tab=liveview']") |> render_click()
      assert has_element?(view, "[id='code-tab-liveview']")

      view |> element("a[href='?tab=vue']") |> render_click()
      assert has_element?(view, "[id='code-tab-vue']")

      view |> element("a[href='?tab=preview']") |> render_click()
      assert has_element?(view, "[id='{example-id}-preview']")
    end

    test "preview tab contains the embedded {Name}Preview LiveView", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/{example-id}?tab=preview")
      assert has_element?(view, "[id='{example-id}-preview']")
    end
  end

  describe "{Name}Preview component" do
    # Test initial state
    test "displays initial state", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/{example-id}?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/{Name}")
      assert vue.props["propName"] == expected_value
    end

    # Test event handling
    test "event updates state", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/{example-id}?tab=preview")

      child_view = find_live_child(view, "{example-id}-preview")
      render_hook(child_view, "event_name", %{"param" => "value"})

      vue = LiveVue.Test.get_vue(view, name: "examples/{Name}")
      assert vue.props["propName"] == new_expected_value
    end

    # Verify component identity
    test "vue component has correct name", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/examples/{example-id}?tab=preview")

      vue = LiveVue.Test.get_vue(view, name: "examples/{Name}")
      assert vue.component == "examples/{Name}"
    end
  end
end
```

### LiveVue.Test Utilities

**Reference:** `deps/live_vue/lib/live_vue/test.ex`

```elixir
# Get Vue component from view
vue = LiveVue.Test.get_vue(view)                          # Only one component
vue = LiveVue.Test.get_vue(view, name: "examples/Counter") # By name
vue = LiveVue.Test.get_vue(view, id: "component-id")      # By ID

# Returned map contains:
vue.component   # "examples/Counter"
vue.props       # %{"count" => 0}
vue.handlers    # Map of event handlers
vue.slots       # Slot content
vue.ssr         # Boolean
```

### Key Testing Patterns

1. **Find child LiveView for event testing:**
   ```elixir
   child_view = find_live_child(view, "{example-id}-preview")
   ```

2. **Send events to child LiveView:**
   ```elixir
   render_hook(child_view, "event_name", %{"param" => "value"})
   ```

3. **Assert props after events:**
   ```elixir
   vue = LiveVue.Test.get_vue(view, name: "examples/Counter")
   assert vue.props["count"] == 5
   ```

4. **Test tab switching:**
   ```elixir
   view |> element("a[href='?tab=liveview']") |> render_click()
   assert has_element?(view, "[id='code-tab-liveview']")
   ```

## Checklist for Creating a New Example

1. **Create Vue component:** `assets/vue/examples/{Name}.vue`
2. **Create preview module:** `lib/live_vue_website_web/live/examples/{snake_name}_preview.ex`
3. **Create full example page:** `lib/live_vue_website_web/live/examples/{snake_name}_live.ex`
4. **Add to catalog:** `lib/live_vue_website/examples.ex`
5. **Add route:** `lib/live_vue_website_web/router.ex`
6. **Create tests:** `test/live_vue_website_web/live/examples/{snake_name}_live_test.exs`
7. **Run precommit:** `mix precommit`

## Available LiveVue Composables

For reference when building examples, these hooks are available from `live_vue`:

- `useLiveVue()` - Push events to server
- `useLiveEvent(name, callback)` - Subscribe to server events
- `useLiveNavigation()` - Navigate/patch routes
- `useLiveUpload(config, options)` - File uploads
- `useLiveConnection()` - Monitor connection status
- `useLiveForm(form, options)` - Form management with validation
- `Link` component - Navigation with `patch`, `navigate`, `href`

## Naming Summary

| Aspect | Convention | Example |
|--------|------------|---------|
| URL | kebab-case | `/examples/simple-form` |
| Catalog ID | kebab-case | `"simple-form"` |
| LiveView module | PascalCase + Live | `SimpleFormLive` |
| Preview module | PascalCase + Preview | `SimpleFormPreview` |
| LiveView file | snake_case + _live.ex | `simple_form_live.ex` |
| Preview file | snake_case + _preview.ex | `simple_form_preview.ex` |
| Vue component | PascalCase.vue | `SimpleForm.vue` |
| Test file | snake_case + _live_test.exs | `simple_form_live_test.exs` |
| v-component | `examples/{PascalCase}` | `examples/SimpleForm` |
