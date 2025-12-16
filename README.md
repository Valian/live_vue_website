<p align="center">
  <img src="priv/static/images/live_vue_logo_v.png" height="128">
  <h1 align="center">LiveVue Website</h1>
</p>

<p align="center">
  <a href="https://livevue.dev">
    <img alt="Live Demo" src="https://img.shields.io/badge/demo-livevue.dev-42b883?style=flat-square">
  </a>
  <a href="https://hex.pm/packages/live_vue">
    <img alt="Hex.pm" src="https://img.shields.io/hexpm/v/live_vue?style=flat-square">
  </a>
  <a href="https://github.com/Valian/live_vue">
    <img alt="GitHub" src="https://img.shields.io/github/stars/Valian/live_vue?style=flat-square">
  </a>
</p>

<p align="center">
  Official showcase website for <a href="https://github.com/Valian/live_vue">LiveVue</a> — Vue.js components inside Phoenix LiveView with seamless end-to-end reactivity.
</p>

---

## What's Inside

- **Landing page** — What LiveVue is, why it exists, interactive demos
- **Live examples** — Working implementations you can explore and learn from
- **Real-time features** — PubSub poll, connection status, Phoenix Streams

## Examples Catalog

### Getting Started
- ⚡ **Counter** — Server state, local Vue state, phx-click, transitions
- 📦 **Custom Encoder** — Pass custom structs with `@derive` and `defimpl`

### Events
- 🎯 **Event Handling** — pushEvent, phx-click, and `useLiveVue()`
- 🔔 **Server Events** — `useLiveEvent()` for server-pushed notifications

### Navigation
- 🔄 **Navigation** — Link component with patch, navigate, href

### Forms
- 📝 **Simple Form** — `useLiveForm()` with Ecto validation
- 📚 **Nested Objects** — Nested fields with dot notation paths
- 📋 **Dynamic Arrays** — `fieldArray()` with add, remove, move

### Uploads
- ☁️ **File Upload** — `useLiveUpload()` with progress tracking

### Real-time
- 📡 **Phoenix Streams** — Efficient list updates with `stream()`
- 📶 **Connection Status** — `useLiveConnection()` for offline handling

### Advanced
- 🧩 **Slots** — Default and named slots with HEEX content
- 🖥️ **SSR Control** — Disable SSR for client-only components

## Development

```bash
mix setup
mix phx.server
```

Visit [localhost:4000](http://localhost:4000).

Run checks before committing:

```bash
mix precommit
```

## Links

- [Live Demo](https://livevue.dev)
- [LiveVue on Hex](https://hex.pm/packages/live_vue)
- [LiveVue Docs](https://hexdocs.pm/live_vue)
- [LiveVue GitHub](https://github.com/Valian/live_vue)
