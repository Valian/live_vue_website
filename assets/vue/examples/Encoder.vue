<script setup lang="ts">
type Business = { name: string; industry: string }
type UserProfile = { name: string; avatar_url: string; business: Business }

const props = defineProps<{
  profile: UserProfile
  profile_original: UserProfile
}>()
</script>

<template>
  <div class="space-y-4">
    <div class="p-4 rounded-lg border border-landing-border">
      <div class="text-xs text-landing-muted mb-3">Default encoding</div>
      <div class="flex items-center gap-3">
        <img :src="props.profile.avatar_url" class="w-12 h-12 rounded-full" />
        <div>
          <div class="font-medium">{{ props.profile.name }}</div>
          <div class="text-landing-muted text-sm">
            {{ props.profile.business.name }}
          </div>
        </div>
      </div>
      <div class="mt-3 text-xs font-mono text-landing-muted truncate">
        Url: {{ props.profile.avatar_url.slice(28, 100) }}
      </div>
    </div>

    <div class="p-4 rounded-lg border border-landing-border">
      <div class="text-xs text-landing-muted mb-3">With <code class="text-phoenix">avatar: :original</code></div>
      <div class="flex items-center gap-3">
        <img :src="props.profile_original.avatar_url" class="w-12 h-12 rounded-full" />
        <div>
          <div class="font-medium">{{ props.profile_original.name }}</div>
          <div class="text-landing-muted text-sm">
            {{ props.profile_original.business.name }}
          </div>
        </div>
      </div>
      <div class="mt-3 text-xs font-mono text-landing-muted truncate">
        Url: {{ props.profile_original.avatar_url.slice(28, 100) }}
      </div>
    </div>
  </div>
</template>
