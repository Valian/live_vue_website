<script setup lang="ts">
import { useLiveUpload, type UploadConfig } from "live_vue"
import { watch } from "vue"

type FileStats = {
  name: string
  size: number
  type: string
}

const props = defineProps<{
  upload: UploadConfig
  uploadedFile: FileStats | null
}>()

const {
  entries,
  showFilePicker,
  addFiles,
  progress,
  cancel,
  submit,
  valid
} = useLiveUpload(() => props.upload, {
  changeEvent: "validate",
  submitEvent: "save"
})

// Auto-submit when upload completes (progress reaches 100%)
watch(progress, (newProgress) => {
  if (newProgress === 100 && entries.value.length > 0 && valid.value) {
    submit()
  }
})

const formatSize = (bytes: number): string => {
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(2)} MB`
}

const handleDrop = (event: DragEvent) => {
  event.preventDefault()
  if (event.dataTransfer) {
    addFiles(event.dataTransfer)
  }
}

const handleDragOver = (event: DragEvent) => {
  event.preventDefault()
}
</script>

<template>
  <div class="card bg-base-200 p-6 space-y-6">
    <template v-if="!uploadedFile">
      <div
        @drop="handleDrop"
        @dragover="handleDragOver"
        :class="[
          'relative border-2 border-dashed rounded-lg p-8 text-center transition-colors cursor-pointer',
          entries.length > 0
            ? 'border-primary bg-primary/5'
            : 'border-base-300 hover:border-primary/50 hover:bg-primary/5'
        ]"
        @click="showFilePicker"
      >
        <div v-if="entries.length === 0" class="space-y-3">
          <div class="mx-auto w-12 h-12 rounded-full bg-primary/10 flex items-center justify-center">
            <svg class="w-6 h-6 text-primary" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
            </svg>
          </div>
          <div>
            <p class="font-medium">Drop a file here</p>
            <p class="text-sm text-neutral mt-1">or click to browse</p>
          </div>
          <p class="text-xs text-neutral">PDF, TXT, PNG, JPG up to 5MB</p>
        </div>

        <div v-else class="space-y-4">
          <div v-for="entry in entries" :key="entry.ref" class="text-left">
            <div class="flex items-center justify-between mb-2">
              <span class="text-sm font-medium truncate max-w-[200px]">
                {{ entry.client_name }}
              </span>
              <button
                type="button"
                class="text-neutral hover:text-error transition-colors p-1"
                @click.stop="cancel(entry.ref)"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                </svg>
              </button>
            </div>
            <progress class="progress progress-primary w-full" :value="entry.progress" max="100"></progress>
            <div class="flex justify-between mt-1 text-xs text-neutral">
              <span>{{ formatSize(entry.client_size) }}</span>
              <span>{{ entry.progress }}%</span>
            </div>
            <div v-if="entry.errors.length > 0" class="mt-2 text-sm text-error">
              {{ entry.errors.join(", ") }}
            </div>
          </div>
        </div>
      </div>

      <div v-if="!valid && entries.length > 0" class="text-sm text-error text-center">
        File validation failed. Please try a different file.
      </div>
    </template>

    <template v-else>
      <div class="space-y-4">
        <div class="flex items-center gap-3">
          <div class="w-10 h-10 rounded-lg bg-success/10 flex items-center justify-center">
            <svg class="w-5 h-5 text-success" fill="none" stroke="currentColor" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
            </svg>
          </div>
          <div>
            <p class="font-medium">Upload complete!</p>
            <p class="text-sm text-neutral">File processed successfully</p>
          </div>
        </div>

        <div class="bg-base-100 rounded-lg p-4 space-y-3">
          <h3 class="text-sm font-medium">File Statistics</h3>
          <div class="grid grid-cols-2 gap-4 text-sm">
            <div>
              <span class="text-neutral">Name</span>
              <p class="font-mono text-xs mt-1 truncate" :title="uploadedFile.name">
                {{ uploadedFile.name }}
              </p>
            </div>
            <div>
              <span class="text-neutral">Size</span>
              <p class="font-mono text-xs mt-1">
                {{ formatSize(uploadedFile.size) }}
              </p>
            </div>
            <div>
              <span class="text-neutral">Type</span>
              <p class="font-mono text-xs mt-1">
                {{ uploadedFile.type || "Unknown" }}
              </p>
            </div>
            <div>
              <span class="text-neutral">Bytes</span>
              <p class="font-mono text-xs mt-1">
                {{ uploadedFile.size.toLocaleString() }}
              </p>
            </div>
          </div>
        </div>

        <button type="button" class="btn btn-outline w-full" phx-click="reset">
          Upload Another File
        </button>
      </div>
    </template>
  </div>
</template>
