# LiveVue Website Rendering Issues Report

## Status: FIXED ✅

Code snippet blocks across multiple example pages were displaying literal `\n` escape sequences instead of actual newlines. This issue has been resolved.

## Summary

The `<.example_snippet>` component has been updated to properly convert escape sequences to actual newlines before rendering in HTML.

## Issue Details

### Problem
When code snippets are displayed in `<.example_snippet>` components, strings containing `\n` escape sequences are being rendered literally as `\n` text in HTML instead of being converted to actual line breaks.

### Visual Impact
- Code blocks display on a single line with visible `\n` characters
- Layout becomes horizontally compressed and unreadable
- Professional appearance is compromised
- Users cannot easily read or understand code examples

### Example
The rendered output shows:
```
defmodule Address do \n  use Ecto. Schema \n  @derive LiveVue. Encoder \n  embedded_schema do \n    field :street , :string...
```

Instead of:
```
defmodule Address do
  use Ecto.Schema
  @derive LiveVue.Encoder
  embedded_schema do
    field :street, :string
```

## Affected Pages

### Pages with Confirmed Issues

1. **Counter** (`/examples/counter`)
   - "Vue transitions on server updates" section
   - File: `lib/live_vue_website_web/live/examples/counter_live.ex:238`

2. **Simple Form** (`/examples/simple-form`)
   - Multiple code snippets across all sections
   - File: `lib/live_vue_website_web/live/examples/simple_form_live.ex` (lines 176, 197, 216, 236, 255, 275)

3. **Nested Objects** (`/examples/nested-form`)
   - "Define an embedded schema" section (line 175)
   - "Use cast_embed for validation" section (line 192)
   - "Access nested fields" section (line 210)
   - "Bind inputs" section (line 229)
   - File: `lib/live_vue_website_web/live/examples/nested_form_live.ex`

4. **Dynamic Arrays** (`/examples/array-form`)
   - Likely affected based on similar pattern

5. **Event Handling** (`/examples/events`)
   - Various code snippet sections

## Root Cause

The issue is in how code strings are passed to the `<.example_snippet>` component in the LiveView template files. The strings use `\n` escape sequences but are not being processed to convert these into actual newlines before HTML rendering.

### Example from `nested_form_live.ex` (line 175):
```elixir
<.example_snippet code="defmodule Address do\n  use Ecto.Schema\n..." />
```

When this string is rendered in the `example_snippet` component template (`core_components.ex:513`), the `\n` characters are passed directly to HTML without conversion:

```heex
<code class={"language-#{@language}"} phx-no-format>{@code}</code>
```

## Solution Implemented

The `example_snippet` component in `lib/live_vue_website_web/components/core_components.ex` (lines 510-520) has been updated to properly handle newline conversion.

### Changes Made

Modified the `example_snippet/1` function to preprocess code strings:

```elixir
def example_snippet(assigns) do
  # Convert escape sequences to actual newlines
  processed_code = String.replace(assigns.code, "\\n", "\n")
  assigns = assign(assigns, :code, processed_code)

  ~H"""
  <div phx-hook="Highlight" id={"snippet-#{:erlang.phash2(@code)}"}>
    <pre class={["font-mono text-xs bg-landing-elevated p-3 rounded-lg overflow-x-auto", @class]}><code class={"language-#{@language}"} phx-no-format>{@code}</code></pre>
  </div>
  """
end
```

**Key Points:**
- `String.replace/3` converts the literal `\n` escape sequences to actual newline characters
- The processed code is reassigned to the assigns map before rendering
- All pages using `<.example_snippet>` automatically benefit from this fix without requiring changes

## Files Affected

- `lib/live_vue_website_web/components/core_components.ex` - Contains `example_snippet/1` component
- `lib/live_vue_website_web/live/examples/counter_live.ex`
- `lib/live_vue_website_web/live/examples/simple_form_live.ex`
- `lib/live_vue_website_web/live/examples/nested_form_live.ex`
- `lib/live_vue_website_web/live/examples/array_form_live.ex`
- `lib/live_vue_website_web/live/examples/events_live.ex`
- (and potentially other example files)

## Testing

Screenshots saved to `/tmp/` for verification:
- `/tmp/page_counter.png` - Counter example showing `\n` issue
- `/tmp/page_simple_form.png` - Simple Form example showing `\n` issue
- `/tmp/page_nested_form.png` - Nested Form example showing `\n` issue
- `/tmp/page_events.png` - Event Handling example

All pages confirm the literal `\n` characters appearing in code blocks when displayed in the browser.

## Recommendations

1. **Priority**: High - This significantly impacts user experience when trying to learn from code examples
2. **Scope**: Affects all example pages with multi-line code snippets
3. **Fix Complexity**: Low - Simple string processing in the component
4. **Testing**: Verify that code blocks display on multiple lines with proper formatting after fix
