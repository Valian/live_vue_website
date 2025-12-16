<script setup lang="ts">
import { useLiveForm, type Form } from "live_vue"

type ContactForm = {
  name: string
  email: string
  consent: boolean
}

const props = defineProps<{ form: Form<ContactForm> }>()

const form = useLiveForm(() => props.form, {
  changeEvent: "validate",
  submitEvent: "submit",
  debounceInMiliseconds: 300
})

const nameField = form.field("name")
const emailField = form.field("email")
const consentField = form.field("consent")
</script>

<template>
  <div class="card bg-base-200 p-6 space-y-6">
    <div class="space-y-4">
      <label class="form-control w-full">
        <div class="label"><span class="label-text">Name</span></div>
        <input
          v-bind="nameField.inputAttrs.value"
          type="text"
          placeholder="Your name"
          :class="[
            'input input-bordered w-full',
            nameField.isTouched.value && nameField.errorMessage.value && 'input-error'
          ]"
        />
        <div v-if="nameField.isTouched.value && nameField.errorMessage.value" class="label">
          <span class="label-text-alt text-error">{{ nameField.errorMessage.value }}</span>
        </div>
      </label>

      <label class="form-control w-full">
        <div class="label"><span class="label-text">Email</span></div>
        <input
          v-bind="emailField.inputAttrs.value"
          type="email"
          placeholder="you@example.com"
          :class="[
            'input input-bordered w-full',
            emailField.isTouched.value && emailField.errorMessage.value && 'input-error'
          ]"
        />
        <div v-if="emailField.isTouched.value && emailField.errorMessage.value" class="label">
          <span class="label-text-alt text-error">{{ emailField.errorMessage.value }}</span>
        </div>
      </label>

      <div class="form-control">
        <label class="label cursor-pointer justify-start gap-3">
          <input
            type="checkbox"
            :checked="consentField.value.value"
            :name="consentField.inputAttrs.value.name"
            :id="consentField.inputAttrs.value.id"
            @change="consentField.value.value = ($event.target as HTMLInputElement).checked"
            @focus="consentField.inputAttrs.value.onFocus"
            @blur="consentField.inputAttrs.value.onBlur"
            :class="['checkbox checkbox-primary', consentField.isTouched.value && consentField.errorMessage.value && 'checkbox-error']"
          />
          <span class="label-text text-neutral">I consent to the processing of my personal data</span>
        </label>
        <div v-if="consentField.isTouched.value && consentField.errorMessage.value" class="label pt-0">
          <span class="label-text-alt text-error">{{ consentField.errorMessage.value }}</span>
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
        <button type="button" class="btn btn-ghost" @click="form.reset()">
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
