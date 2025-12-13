// Syntax highlighting with highlight.js
import hljs from "highlight.js/lib/core"
import elixir from "highlight.js/lib/languages/elixir"
import xml from "highlight.js/lib/languages/xml"
import javascript from "highlight.js/lib/languages/javascript"
import typescript from "highlight.js/lib/languages/typescript"

hljs.registerLanguage("elixir", elixir)
hljs.registerLanguage("xml", xml)
hljs.registerLanguage("javascript", javascript)
hljs.registerLanguage("typescript", typescript)
hljs.registerLanguage("vue", xml)

// Highlight code blocks
function highlightAll() {
  document.querySelectorAll("pre code[class*='language-']").forEach((el) => {
    if (!el.dataset.highlighted) {
      hljs.highlightElement(el)
    }
  })
}

// Hook for highlighting code blocks in LiveView
export const Highlight = {
  mounted() {
    this.highlight()
  },
  updated() {
    this.highlight()
  },
  highlight() {
    this.el.querySelectorAll("code[class*='language-']").forEach((el) => {
      if (!el.dataset.highlighted) {
        hljs.highlightElement(el)
      }
    })
  }
}

// Also run on page events for navigation
window.addEventListener("phx:page-loading-stop", highlightAll)
