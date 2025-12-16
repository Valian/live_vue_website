<script setup lang="ts">
import { useLiveForm, type Form } from "live_vue"

type ContactForm = {
  name: string
  email: string
  consent: boolean
}

const props = defineProps<{ form: Form<ContactForm>; submitted: ContactForm | null }>()

const form = useLiveForm(() => props.form, {
  changeEvent: "validate",
  submitEvent: "submit",
  debounceInMiliseconds: 300,
})

const nameField = form.field("name")
const emailField = form.field("email")
const consentField = form.field("consent", { type: "checkbox" })
</script>

<template>
  <div class="card bg-base-200 p-6 space-y-6">
    <div class="flex flex-col gap-6">
      <label class="form-control w-full">
        <div class="label pb-2"><span class="label-text font-medium">Name</span></div>
        <input
          v-bind="nameField.inputAttrs.value"
          type="text"
          placeholder="Your name"
          :class="[
            'input input-bordered w-full',
            nameField.isTouched.value && nameField.errorMessage.value && 'input-error',
          ]"
        />
        <div v-if="nameField.isTouched.value && nameField.errorMessage.value" class="label">
          <span class="label-text-alt text-error">{{ nameField.errorMessage.value }}</span>
        </div>
      </label>

      <label class="form-control w-full">
        <div class="label pb-2"><span class="label-text font-medium">Email</span></div>
        <input
          v-bind="emailField.inputAttrs.value"
          type="email"
          placeholder="you@example.com"
          :class="[
            'input input-bordered w-full',
            emailField.isTouched.value && emailField.errorMessage.value && 'input-error',
          ]"
        />
        <div v-if="emailField.isTouched.value && emailField.errorMessage.value" class="label">
          <span class="label-text-alt text-error">{{ emailField.errorMessage.value }}</span>
        </div>
      </label>

      <div class="form-control pt-2">
        <label class="label cursor-pointer justify-start gap-3">
          <input
            v-bind="consentField.inputAttrs.value"
            :class="[
              'checkbox checkbox-primary',
              consentField.isTouched.value && consentField.errorMessage.value && 'checkbox-error',
            ]"
          />
          <span class="label-text">I consent to the processing of my personal data</span>
        </label>
        <div v-if="consentField.isTouched.value && consentField.errorMessage.value" class="label pt-0">
          <span class="label-text-alt text-error">{{ consentField.errorMessage.value }}</span>
        </div>
      </div>
    </div>

    <div class="flex items-center justify-between pt-2">
      <div class="flex items-center gap-3">
        <button type="button" :disabled="!form.isValid.value" class="btn btn-primary" @click="form.submit()">
          Submit
        </button>
        <button type="button" class="btn btn-ghost" @click="form.reset()">Reset</button>
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

    <div v-if="props.submitted" class="mt-6 p-4 bg-success/10 border border-success/20 rounded-lg">
      <div class="text-sm font-medium text-success mb-2">Submitted Data:</div>
      <pre class="text-xs overflow-auto">{{ JSON.stringify(props.submitted, null, 2) }}</pre>
    </div>
  </div>
</template>
