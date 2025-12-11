# Landing Page Content

Design inspired by VuePress/VitePress landing pages (VueUse, Pinia, Vue.js).
Color scheme: Phoenix orange (#FD4F00) + Vue green (#42b883), duotone.

---

## Hero (Option D selected)

**Headline**: Vue inside Phoenix LiveView with seamless end-to-end reactivity.

**Tagline**: Forms, uploads, streams, events — all working. Plus instant reload and SSR.

**CTA**: Get Started → | Examples →

### Hero Animation

Animated diagram showing the data/event flow between three layers:

```
┌─────────────────────────────────────────────────────────────────┐
│  SERVER (LiveView)                                              │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  assigns = %{count: 5, user: %{name: "Alice"}}          │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
                          │                        ▲
                          │ props                  │ events
                          │ (auto-sync)            │ (pushEvent)
                          ▼                        │
┌─────────────────────────────────────────────────────────────────┐
│  CLIENT (Vue Component)                                         │
│  ┌──────────────────────┐  ┌────────────────────────────────┐  │
│  │  props (from server) │  │  local state (Vue refs)        │  │
│  │  count: 5            │  │  filter: "all"                 │  │
│  │  user: {name: "..."}│  │  isOpen: false                 │  │
│  └──────────────────────┘  └────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
                          │
                          │ reactivity
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│  DOM                                                            │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  <p>Count: 5</p>                                        │   │
│  │  <button @click="filter = 'active'">Active</button>     │   │
│  │  <button phx-click="increment">+1</button>              │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

**Animation sequence** (loops):

1. **Initial state**: All three boxes visible, arrows dim
2. **Local event**:
   - User clicks "Active" button in DOM (highlight button)
   - Arrow pulses from DOM → Client local state
   - `filter` changes from "all" to "active" (highlight change)
   - DOM updates to show filtered view
   - Label: "Local state stays client-side"

3. **Server event**:
   - User clicks "+1" button in DOM (highlight button)
   - Arrow pulses from DOM → Client → Server
   - Server `count` changes from 5 to 6 (highlight change)
   - Arrow pulses from Server → Client (props sync)
   - Client `props.count` updates (highlight)
   - DOM updates to show "Count: 6"
   - Label: "Server state syncs automatically"

4. **Brief pause, then loop**

**Visual style**:
- Boxes: Rounded rectangles with subtle shadows
- Server box: Phoenix orange border/accent
- Client box: Vue green border/accent
- DOM box: Neutral/gray
- Arrows: Animated dashed lines that "flow" in direction of data
- Highlights: Gentle pulse/glow when values change
- Code inside boxes: Monospace, syntax-colored

**Interaction** (optional):
- Clickable buttons in the DOM section that trigger the animations manually
- Or just auto-play on loop with controls to pause

**Fallback for reduced-motion**:
- Static diagram with all arrows visible
- Or simplified version with just the three boxes and bidirectional arrows

---

## Features Grid

Six features, icon + title + one-liner (VuePress style):

| Icon | Title | Description |
|------|-------|-------------|
| ⚡ | End-to-End Reactivity | Props flow from LiveView assigns. Changes sync automatically. |
| 🔧 | Built for LiveView | Not a wrapper or adapter. Designed for LiveView's architecture. |
| 🖥️ | Server-Side Rendered | Vue components render on first paint. No loading flash. |
| 📦 | Efficient Updates | Only changed props sent via JSON patches over WebSocket. |
| 🎯 | TypeScript Ready | Full type safety for props, events, and composables. |
| 🚀 | One-Line Install | `mix igniter.install live_vue` handles setup automatically. |

---

## Code Example

Side-by-side showing the mental model:

**Vue Component**
```vue
<script setup lang="ts">
import { ref } from "vue"

const props = defineProps<{ count: number }>()
const diff = ref(1)
</script>

<template>
  <p>Count: {{ props.count }}</p>
  <input v-model.number="diff" type="range" min="1" max="10" />
  <button phx-click="inc" :phx-value-diff="diff">
    +{{ diff }}
  </button>
</template>
```

**LiveView**
```elixir
defmodule MyAppWeb.CounterLive do
  use MyAppWeb, :live_view

  def render(assigns) do
    ~H"""
    <.vue count={@count} v-component="Counter" v-socket={@socket} />
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0)}
  end

  def handle_event("inc", %{"diff" => diff}, socket) do
    {:noreply, update(socket, :count, &(&1 + diff))}
  end
end
```

Caption: Props in, events out. Server owns the state.

---

## What Works

Section showing LiveView features that work in LiveVue:

### Forms & Validation
Ecto changesets work the same way. `useLiveForm()` provides the same validation flow you'd use in HEEX.

```vue
<script setup lang="ts">
import { useLiveForm, type Form } from "live_vue"

const props = defineProps<{ form: Form<{ email: string }> }>()

const { field, submit, isValid } = useLiveForm(() => props.form, {
  submitEvent: "save",
  changeEvent: "validate"
})

const emailField = field("email")
</script>

<template>
  <input v-bind="emailField.inputAttrs.value" type="email" />
  <span v-if="emailField.errorMessage.value">
    {{ emailField.errorMessage.value }}
  </span>
  <button @click="submit" :disabled="!isValid">Save</button>
</template>
```

### Streams
Pass `@streams.items` as a prop. LiveVue applies patches efficiently.

```elixir
def render(assigns) do
  ~H"""
  <.vue items={@streams.messages} v-component="MessageList" v-socket={@socket} />
  """
end

def mount(_params, _session, socket) do
  {:ok, stream(socket, :messages, Messages.list_recent())}
end
```

### File Uploads
`useLiveUpload()` wraps LiveView's upload system. Same backend, Vue-friendly API.

```vue
<script setup lang="ts">
import { useLiveUpload, type UploadConfig } from "live_vue"

const props = defineProps<{ upload: UploadConfig }>()

const { entries, showFilePicker, progress, submit } = useLiveUpload(
  () => props.upload,
  { submitEvent: "save" }
)
</script>

<template>
  <button @click="showFilePicker">Choose files</button>
  <div v-for="entry in entries" :key="entry.ref">
    {{ entry.client_name }} — {{ entry.progress }}%
  </div>
  <button @click="submit">Upload</button>
</template>
```

### Events

```vue
<script setup>
import { useLiveVue, useLiveEvent } from "live_vue"

const live = useLiveVue()

// Push to server
live.pushEvent("increment", { amount: 5 })

// Receive from server
useLiveEvent("notification", (data) => {
  console.log(data.message)
})
</script>

<template>
  <!-- Or use $live directly in templates -->
  <button @click="$live.pushEvent('save', { id: 1 })">Save</button>
</template>
```

### Navigation
`<Link>` component for `patch` and `navigate`. Programmatic navigation via `useLiveNavigation()`.

```vue
<script setup>
import { Link, useLiveNavigation } from "live_vue"

const { patch, navigate } = useLiveNavigation()
</script>

<template>
  <Link href="/about">About</Link>
  <Link patch="/users?page=2">Page 2</Link>
  <Link navigate="/dashboard">Dashboard</Link>
</template>
```

---

## Use Cases

When LiveVue makes sense:

- **Rich interactions** — Drag-and-drop, animations, complex local state
- **Third-party libraries** — Chart.js, TipTap, Vue ecosystem packages
- **Team familiarity** — Your team knows Vue and wants to use it
- **Gradual adoption** — Start with one component, expand as needed

When plain LiveView is enough:

- Forms, tables, simple interactions
- Server-rendered content with minimal JS
- When you don't need the Vue runtime (~34kb gzipped)

---

## Two Approaches

### Embedded Components
Vue handles interactive islands. Phoenix renders the layout.

```elixir
def render(assigns) do
  ~H"""
  <Layouts.app flash={@flash}>
    <h1>Dashboard</h1>
    <.vue data={@metrics} v-component="Chart" v-socket={@socket} />
  </Layouts.app>
  """
end
```

### Full Vue Layouts
Vue renders everything. LiveView manages state and routing.

```elixir
def render(assigns) do
  ~H"""
  <.vue v-component="App" v-socket={@socket} {@props} />
  """
end
```

---

## Quick Start

```bash
# New project
mix igniter.new my_app --with phx.new --install live_vue

# Existing project
mix igniter.install live_vue
```

Create a component:

```vue
<!-- assets/vue/Counter.vue -->
<script setup lang="ts">
const props = defineProps<{ count: number }>()
</script>

<template>
  <p>Count: {{ props.count }}</p>
  <button phx-click="increment">+1</button>
</template>
```

Use it:

```elixir
<.vue count={@count} v-component="Counter" v-socket={@socket} />
```

---

## Comparisons

Positioned as informative, not competitive.

### vs Pure LiveView
LiveView is excellent for most UI work. LiveVue adds Vue when you need:
- Complex client-side state
- Vue ecosystem libraries
- Component patterns that map better to Vue

### vs Inertia.js
Different goals. Inertia replaces LiveView with a request/response model. LiveVue keeps LiveView's WebSocket connection and real-time capabilities.

### vs LiveSvelte / LiveReact
Same idea, different framework. Choose based on team preference and ecosystem needs.

---

## Interactive Examples

Ideas for embedded demos:

1. **Counter** — Simplest possible example. Server state + local state (slider).
2. **Todo List** — Form validation with `useLiveForm()`, events, client-side filtering.
3. **File Upload** — Progress tracking, drag-drop with `useLiveUpload()`.
4. **Real-time Chart** — PubSub updates rendered in Vue.

Each shows the Vue component and LiveView code side by side.

---

## Design Notes

**Architecture**: HEEX layout with Vue islands. Dogfoods the embedded mode.

- Static content (nav, text, feature grid, footer) rendered in HEEX
- Interactive elements as Vue components:
  - `<.vue v-component="HeroAnimation" ... />`
  - `<.vue v-component="CounterDemo" ... />`
  - `<.vue v-component="TodoDemo" ... />`
- SPA mode demonstrated on a separate example page, not the landing page itself

**Layout**: Single-page marketing with sections. Sticky nav with: Home | Examples | Docs | GitHub

**Typography**: Clean, technical. Similar to VitePress default theme.

**Colors**:
- Primary: Phoenix orange (#FD4F00)
- Secondary: Vue green (#42b883)
- Background: Light neutral or dark mode toggle
- Code blocks: Syntax highlighted, both Elixir and Vue

**Spacing**: Generous whitespace. Let the code breathe.

**Mobile**: Responsive. Code examples may need horizontal scroll on small screens.
