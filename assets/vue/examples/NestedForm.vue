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

const props = defineProps<{ form: Form<ProfileForm> }>()

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
  <div class="p-6 rounded-xl border border-landing-border space-y-6">
    <div class="space-y-4">
      <div class="space-y-2">
        <label class="text-sm font-medium text-landing-text">Name</label>
        <input
          v-bind="nameField.inputAttrs.value"
          type="text"
          placeholder="Your name"
          :class="[
            'w-full px-3 py-2 rounded border bg-transparent text-landing-text placeholder:text-landing-muted/50 transition-colors',
            nameField.isTouched.value && nameField.errorMessage.value
              ? 'border-red-500/50 focus:border-red-500'
              : 'border-landing-border focus:border-vue'
          ]"
        />
        <div
          v-if="nameField.isTouched.value && nameField.errorMessage.value"
          class="text-sm text-red-400"
        >
          {{ nameField.errorMessage.value }}
        </div>
      </div>

      <div class="space-y-2">
        <label class="text-sm font-medium text-landing-text">Email</label>
        <input
          v-bind="emailField.inputAttrs.value"
          type="email"
          placeholder="you@example.com"
          :class="[
            'w-full px-3 py-2 rounded border bg-transparent text-landing-text placeholder:text-landing-muted/50 transition-colors',
            emailField.isTouched.value && emailField.errorMessage.value
              ? 'border-red-500/50 focus:border-red-500'
              : 'border-landing-border focus:border-vue'
          ]"
        />
        <div
          v-if="emailField.isTouched.value && emailField.errorMessage.value"
          class="text-sm text-red-400"
        >
          {{ emailField.errorMessage.value }}
        </div>
      </div>

      <div class="pt-4 border-t border-landing-border/50">
        <div class="text-sm font-medium text-landing-muted mb-3">Address</div>

        <div class="space-y-4">
          <div class="space-y-2">
            <label class="text-sm font-medium text-landing-text">Street</label>
            <input
              v-bind="streetField.inputAttrs.value"
              type="text"
              placeholder="123 Main St"
              :class="[
                'w-full px-3 py-2 rounded border bg-transparent text-landing-text placeholder:text-landing-muted/50 transition-colors',
                streetField.isTouched.value && streetField.errorMessage.value
                  ? 'border-red-500/50 focus:border-red-500'
                  : 'border-landing-border focus:border-vue'
              ]"
            />
            <div
              v-if="streetField.isTouched.value && streetField.errorMessage.value"
              class="text-sm text-red-400"
            >
              {{ streetField.errorMessage.value }}
            </div>
          </div>

          <div class="grid grid-cols-2 gap-4">
            <div class="space-y-2">
              <label class="text-sm font-medium text-landing-text">City</label>
              <input
                v-bind="cityField.inputAttrs.value"
                type="text"
                placeholder="San Francisco"
                :class="[
                  'w-full px-3 py-2 rounded border bg-transparent text-landing-text placeholder:text-landing-muted/50 transition-colors',
                  cityField.isTouched.value && cityField.errorMessage.value
                    ? 'border-red-500/50 focus:border-red-500'
                    : 'border-landing-border focus:border-vue'
                ]"
              />
              <div
                v-if="cityField.isTouched.value && cityField.errorMessage.value"
                class="text-sm text-red-400"
              >
                {{ cityField.errorMessage.value }}
              </div>
            </div>

            <div class="space-y-2">
              <label class="text-sm font-medium text-landing-text">ZIP</label>
              <input
                v-bind="zipField.inputAttrs.value"
                type="text"
                placeholder="94102"
                :class="[
                  'w-full px-3 py-2 rounded border bg-transparent text-landing-text placeholder:text-landing-muted/50 transition-colors',
                  zipField.isTouched.value && zipField.errorMessage.value
                    ? 'border-red-500/50 focus:border-red-500'
                    : 'border-landing-border focus:border-vue'
                ]"
              />
              <div
                v-if="zipField.isTouched.value && zipField.errorMessage.value"
                class="text-sm text-red-400"
              >
                {{ zipField.errorMessage.value }}
              </div>
            </div>
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
