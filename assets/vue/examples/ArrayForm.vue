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
  <div class="card bg-base-200 p-6 space-y-6">
    <div class="space-y-4">
      <label class="form-control w-full">
        <div class="label"><span class="label-text">Title</span></div>
        <input
          v-bind="titleField.inputAttrs.value"
          type="text"
          placeholder="Enter a title"
          :class="[
            'input input-bordered w-full',
            titleField.isTouched.value && titleField.errorMessage.value && 'input-error'
          ]"
        />
        <div v-if="titleField.isTouched.value && titleField.errorMessage.value" class="label">
          <span class="label-text-alt text-error">{{ titleField.errorMessage.value }}</span>
        </div>
      </label>

      <div class="pt-4 border-t border-base-300">
        <div class="flex items-center justify-between mb-3">
          <div class="text-sm font-medium text-neutral">Tags</div>
          <button
            type="button"
            class="btn btn-xs btn-primary btn-outline"
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
            <div class="flex-1">
              <input
                v-bind="tagField.field('name').inputAttrs.value"
                type="text"
                :placeholder="`Tag ${index + 1}`"
                :class="[
                  'input input-bordered w-full',
                  tagField.field('name').isTouched.value && tagField.field('name').errorMessage.value && 'input-error'
                ]"
              />
              <div
                v-if="tagField.field('name').isTouched.value && tagField.field('name').errorMessage.value"
                class="label pt-1"
              >
                <span class="label-text-alt text-error">{{ tagField.field('name').errorMessage.value }}</span>
              </div>
            </div>
            <button
              type="button"
              class="btn btn-ghost btn-sm text-neutral hover:text-error shrink-0"
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
            class="text-sm text-neutral/50 py-4 text-center border border-dashed border-base-300 rounded"
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
          class="btn btn-primary"
          @click="form.submit()"
        >
          Submit
        </button>
        <button
          type="button"
          class="btn btn-ghost"
          @click="form.reset()"
        >
          Reset
        </button>
      </div>
      <div class="flex items-center gap-4 text-xs">
        <span :class="form.isDirty.value ? 'text-primary' : 'text-neutral/50'">
          {{ form.isDirty.value ? "Modified" : "Unchanged" }}
        </span>
        <span :class="form.isValid.value ? 'text-success' : 'text-error'">
          {{ form.isValid.value ? "Valid" : "Invalid" }}
        </span>
      </div>
    </div>
  </div>
</template>
