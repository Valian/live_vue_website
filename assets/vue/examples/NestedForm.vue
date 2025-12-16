<script setup lang="ts">
import { useLiveForm, type Form } from "live_vue"

type ProfileForm = {
  name: string
  email: string
  address: {
    street: string
    city: string
    zip: string
  }
}

const props = defineProps<{ form: Form<ProfileForm>; submitted: ProfileForm | null }>()

const form = useLiveForm(() => props.form, {
  changeEvent: "validate",
  submitEvent: "submit",
  debounceInMiliseconds: 300
})

const nameField = form.field("name")
const emailField = form.field("email")
const streetField = form.field("address.street")
const cityField = form.field("address.city")
const zipField = form.field("address.zip")
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
            nameField.isTouched.value && nameField.errorMessage.value && 'input-error'
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
            emailField.isTouched.value && emailField.errorMessage.value && 'input-error'
          ]"
        />
        <div v-if="emailField.isTouched.value && emailField.errorMessage.value" class="label">
          <span class="label-text-alt text-error">{{ emailField.errorMessage.value }}</span>
        </div>
      </label>

      <div class="pt-4 border-t border-base-300">
        <div class="text-sm font-medium mb-4">Address</div>

        <div class="flex flex-col gap-6">
          <label class="form-control w-full">
            <div class="label pb-2"><span class="label-text font-medium">Street</span></div>
            <input
              v-bind="streetField.inputAttrs.value"
              type="text"
              placeholder="123 Main St"
              :class="[
                'input input-bordered w-full',
                streetField.isTouched.value && streetField.errorMessage.value && 'input-error'
              ]"
            />
            <div v-if="streetField.isTouched.value && streetField.errorMessage.value" class="label">
              <span class="label-text-alt text-error">{{ streetField.errorMessage.value }}</span>
            </div>
          </label>

          <div class="grid grid-cols-2 gap-4">
            <label class="form-control w-full">
              <div class="label pb-2"><span class="label-text font-medium">City</span></div>
              <input
                v-bind="cityField.inputAttrs.value"
                type="text"
                placeholder="San Francisco"
                :class="[
                  'input input-bordered w-full',
                  cityField.isTouched.value && cityField.errorMessage.value && 'input-error'
                ]"
              />
              <div v-if="cityField.isTouched.value && cityField.errorMessage.value" class="label">
                <span class="label-text-alt text-error">{{ cityField.errorMessage.value }}</span>
              </div>
            </label>

            <label class="form-control w-full">
              <div class="label pb-2"><span class="label-text font-medium">ZIP</span></div>
              <input
                v-bind="zipField.inputAttrs.value"
                type="text"
                placeholder="94102"
                :class="[
                  'input input-bordered w-full',
                  zipField.isTouched.value && zipField.errorMessage.value && 'input-error'
                ]"
              />
              <div v-if="zipField.isTouched.value && zipField.errorMessage.value" class="label">
                <span class="label-text-alt text-error">{{ zipField.errorMessage.value }}</span>
              </div>
            </label>
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

    <div v-if="props.submitted" class="mt-6 p-4 bg-success/10 border border-success/20 rounded-lg">
      <div class="text-sm font-medium text-success mb-2">Submitted Data:</div>
      <pre class="text-xs overflow-auto">{{ JSON.stringify(props.submitted, null, 2) }}</pre>
    </div>
  </div>
</template>
