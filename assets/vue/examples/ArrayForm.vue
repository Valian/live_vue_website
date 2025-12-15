<script setup lang="ts">
import { useLiveForm, type Form } from "live_vue"

type Tag = {
  name: string
}

type PostForm = {
  title: string
  tags: Tag[]
}

const props = defineProps<{ form: Form<PostForm> }>()

const form = useLiveForm(() => props.form, {
  changeEvent: "validate",
  submitEvent: "submit",
  debounceInMiliseconds: 300
})

const titleField = form.field("title")
const tagsArray = form.fieldArray("tags")
</script>

<template>
  <div class="p-6 rounded-xl border border-landing-border space-y-6">
    <div class="space-y-4">
      <div class="space-y-2">
        <label class="text-sm font-medium text-landing-text">Title</label>
        <input
          v-bind="titleField.inputAttrs.value"
          type="text"
          placeholder="Enter a title"
          :class="[
            'w-full px-3 py-2 rounded border bg-transparent text-landing-text placeholder:text-landing-muted/50 transition-colors',
            titleField.isTouched.value && titleField.errorMessage.value
              ? 'border-red-500/50 focus:border-red-500'
              : 'border-landing-border focus:border-vue'
          ]"
        />
        <div
          v-if="titleField.isTouched.value && titleField.errorMessage.value"
          class="text-sm text-red-400"
        >
          {{ titleField.errorMessage.value }}
        </div>
      </div>

      <div class="pt-4 border-t border-landing-border/50">
        <div class="flex items-center justify-between mb-3">
          <div class="text-sm font-medium text-landing-muted">Tags</div>
          <button
            type="button"
            class="text-xs px-2 py-1 rounded bg-vue/10 text-vue hover:bg-vue/20 transition-colors"
            @click="tagsArray.add({ name: '' })"
          >
            + Add Tag
          </button>
        </div>

        <div class="space-y-2">
          <div
            v-for="(tagField, index) in tagsArray.fields.value"
            :key="index"
            class="flex gap-2 items-start"
          >
            <div class="flex-1 space-y-1">
              <input
                v-bind="tagField.field('name').inputAttrs.value"
                type="text"
                :placeholder="`Tag ${index + 1}`"
                :class="[
                  'w-full px-3 py-2 rounded border bg-transparent text-landing-text placeholder:text-landing-muted/50 transition-colors',
                  tagField.field('name').isTouched.value && tagField.field('name').errorMessage.value
                    ? 'border-red-500/50 focus:border-red-500'
                    : 'border-landing-border focus:border-vue'
                ]"
              />
              <div
                v-if="tagField.field('name').isTouched.value && tagField.field('name').errorMessage.value"
                class="text-sm text-red-400"
              >
                {{ tagField.field('name').errorMessage.value }}
              </div>
            </div>
            <button
              type="button"
              class="p-2 text-landing-muted hover:text-red-400 transition-colors shrink-0"
              @click="tagsArray.remove(index)"
            >
              <svg class="w-5 h-5" viewBox="0 0 20 20" fill="currentColor">
                <path
                  fill-rule="evenodd"
                  d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z"
                  clip-rule="evenodd"
                />
              </svg>
            </button>
          </div>
          <div
            v-if="tagsArray.fields.value.length === 0"
            class="text-sm text-landing-muted/50 py-4 text-center border border-dashed border-landing-border rounded"
          >
            No tags yet. Click "Add Tag" to start.
          </div>
        </div>
      </div>
    </div>

    <div class="flex items-center justify-between pt-2">
      <div class="flex items-center gap-3">
        <button
          type="button"
          :disabled="!form.isValid.value"
          :class="[
            'px-4 py-2 rounded font-medium transition-colors',
            form.isValid.value
              ? 'bg-vue text-white hover:bg-vue/90'
              : 'bg-landing-border text-landing-muted cursor-not-allowed'
          ]"
          @click="form.submit()"
        >
          Submit
        </button>
        <button
          type="button"
          class="px-4 py-2 border border-landing-border rounded text-landing-muted hover:text-landing-text hover:bg-white/5 transition-colors"
          @click="form.reset()"
        >
          Reset
        </button>
      </div>
      <div class="flex items-center gap-4 text-xs">
        <span :class="form.isDirty.value ? 'text-vue' : 'text-landing-muted/50'">
          {{ form.isDirty.value ? "Modified" : "Unchanged" }}
        </span>
        <span :class="form.isValid.value ? 'text-green-400' : 'text-red-400'">
          {{ form.isValid.value ? "Valid" : "Invalid" }}
        </span>
      </div>
    </div>
  </div>
</template>
