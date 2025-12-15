<script setup lang="ts">
type Business = {
  name: string
  industry: string
}

type UserProfile = {
  name: string
  email: string
  avatar_url: string
  business: Business
}

const props = defineProps<{
  profile: UserProfile
  profile_with_original_avatar: UserProfile
}>()
</script>

<template>
  <div class="space-y-6">
    <div class="p-6 rounded-xl border border-landing-border">
      <h3 class="text-sm font-medium text-landing-muted mb-4">Default encoding</h3>
      <div class="flex items-center gap-4">
        <img
          :src="props.profile.avatar_url"
          :alt="props.profile.name"
          class="w-16 h-16 rounded-full object-cover"
        />
        <div>
          <div class="font-medium text-lg">{{ props.profile.name }}</div>
          <div class="text-landing-muted text-sm">{{ props.profile.email }}</div>
          <div class="text-landing-muted text-xs mt-1">
            {{ props.profile.business.name }} &middot; {{ props.profile.business.industry }}
          </div>
        </div>
      </div>
      <div class="mt-4 text-xs text-landing-muted font-mono bg-landing-elevated p-2 rounded">
        avatar_url: {{ props.profile.avatar_url }}
      </div>
    </div>

    <div class="p-6 rounded-xl border border-landing-border">
      <h3 class="text-sm font-medium text-landing-muted mb-4">With <code class="text-phoenix">avatar: :original</code> option</h3>
      <div class="flex items-center gap-4">
        <img
          :src="props.profile_with_original_avatar.avatar_url"
          :alt="props.profile_with_original_avatar.name"
          class="w-16 h-16 rounded-full object-cover"
        />
        <div>
          <div class="font-medium text-lg">{{ props.profile_with_original_avatar.name }}</div>
          <div class="text-landing-muted text-sm">{{ props.profile_with_original_avatar.email }}</div>
          <div class="text-landing-muted text-xs mt-1">
            {{ props.profile_with_original_avatar.business.name }} &middot; {{ props.profile_with_original_avatar.business.industry }}
          </div>
        </div>
      </div>
      <div class="mt-4 text-xs text-landing-muted font-mono bg-landing-elevated p-2 rounded">
        avatar_url: {{ props.profile_with_original_avatar.avatar_url }}
      </div>
    </div>
  </div>
</template>
