# DaisyUI Migration Guide for Vue Examples

This document describes how to migrate Vue example components from verbose Tailwind CSS to semantic daisyUI classes.

## Theme Color Mapping

The daisyUI theme has been configured with these semantic colors:

| Old Class | New Class | Meaning |
|-----------|-----------|---------|
| `text-vue`, `bg-vue` | `text-primary`, `bg-primary` | Vue green (#42b883) |
| `text-phoenix`, `bg-phoenix` | `text-secondary`, `bg-secondary` | Phoenix orange (#FD4F00) |
| `text-landing-muted` | `text-neutral` | Muted/secondary text |
| `text-landing-text` | `text-base-content` | Primary text (or omit, it's default) |
| `border-landing-border` | `border-base-300` | Border color |
| `bg-landing-elevated` | `bg-base-200` | Elevated background |
| `bg-landing-card` | `bg-base-300` | Card background |
| `text-green-400` | `text-success` | Success state |
| `text-red-400`, `text-red-500` | `text-error` | Error state |

## Component Replacements

### Container/Card
```vue
<!-- Before -->
<div class="p-6 rounded-xl border border-landing-border">

<!-- After -->
<div class="card bg-base-200 p-6">
```

### Buttons
```vue
<!-- Before: Primary action -->
<button class="px-4 py-2 bg-vue text-white rounded font-medium hover:bg-vue/90">
<button class="px-4 py-2 bg-phoenix text-white rounded">

<!-- After -->
<button class="btn btn-primary">
<button class="btn btn-secondary">

<!-- Before: Ghost/outline -->
<button class="px-4 py-2 border border-landing-border rounded text-landing-muted hover:text-landing-text hover:bg-white/5 transition-colors">

<!-- After -->
<button class="btn btn-ghost">
<button class="btn btn-outline">
```

### Text Inputs
```vue
<!-- Before -->
<input
  type="text"
  :class="[
    'w-full px-3 py-2 rounded border bg-transparent text-landing-text placeholder:text-landing-muted/50 transition-colors',
    hasError ? 'border-red-500/50 focus:border-red-500' : 'border-landing-border focus:border-vue'
  ]"
/>

<!-- After -->
<input
  type="text"
  :class="['input input-bordered w-full', hasError && 'input-error']"
/>
```

### Form Controls with Labels
```vue
<!-- Before -->
<div class="space-y-2">
  <label class="text-sm font-medium text-landing-text">Name</label>
  <input ... />
  <div v-if="error" class="text-sm text-red-400">{{ error }}</div>
</div>

<!-- After -->
<label class="form-control w-full">
  <div class="label"><span class="label-text">Name</span></div>
  <input ... />
  <div v-if="error" class="label">
    <span class="label-text-alt text-error">{{ error }}</span>
  </div>
</label>
```

### Checkboxes
```vue
<!-- Before -->
<input
  type="checkbox"
  class="mt-1 w-4 h-4 rounded border bg-transparent transition-colors accent-vue border-landing-border"
/>

<!-- After -->
<input type="checkbox" class="checkbox checkbox-primary" />
```

### Range Inputs
```vue
<!-- Before -->
<input type="range" class="w-full accent-vue" />

<!-- After -->
<input type="range" class="range range-primary range-sm" />
```

### Progress Bars
```vue
<!-- Before -->
<div class="h-2 bg-landing-border rounded-full overflow-hidden">
  <div class="h-full bg-vue transition-all" :style="{ width: `${progress}%` }" />
</div>

<!-- After -->
<progress class="progress progress-primary" :value="progress" max="100"></progress>
```

### Badges/Tags
```vue
<!-- Before -->
<span class="px-2 py-0.5 rounded text-xs font-mono bg-vue/20 text-vue">

<!-- After -->
<span class="badge badge-primary badge-outline">
```

## Key Principles

1. **Keep it simple**: daisyUI classes should reduce verbosity, not add complexity
2. **Preserve functionality**: Don't change component behavior, only styling
3. **Use semantic colors**: `primary`, `secondary`, `neutral`, `success`, `error` instead of hardcoded colors
4. **Consistent patterns**: All examples should use the same daisyUI patterns
5. **Minimal custom CSS**: Only keep scoped styles that can't be replaced (like Vue transitions)

## Reference Examples

See these already-migrated files for patterns:
- `assets/vue/examples/Counter.vue` - buttons, range input, card container
- `assets/vue/examples/SimpleForm.vue` - form controls, inputs, checkboxes, error states
