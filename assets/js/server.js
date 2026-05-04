import components from "../vue"
import manifest from "live_vue/ssrManifest"
import { getRender } from "live_vue/server"

export const render = getRender(components, manifest)
