# LiveVue Examples Page Design

## Overview

A dedicated Examples page showcasing LiveVue features with live, interactive demos and source code.

## Architecture Decisions

### 1. Code Display Strategy

**Compile-time file embedding via macro**

```elixir
# Use @external_resource to trigger recompilation when source files change
@external_resource "assets/vue/examples/Counter.vue"
@vue_source File.read!("assets/vue/examples/Counter.vue")
```

This ensures:
- Code is always in sync with actual implementation
- No runtime file reading overhead
- Automatic recompilation when example files change

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
  examples_live.ex          # Index/layout with side nav
  counter_live.ex           # Counter example
  events_live.ex            # Events example
  forms_live.ex             # Forms example
  uploads_live.ex           # Uploads example
  ...

assets/vue/examples/
  Counter.vue
  EventsDemo.vue
  SimpleForm.vue
  FileUpload.vue
  ...
```

## Component Reuse

Create shared components for:
- `ExampleLayout` - Side nav + content area
- `CodeBlock` - Syntax highlighted code with copy button
- `TabGroup` - Preview/LiveView/Vue tabs
