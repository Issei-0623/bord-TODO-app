import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { timeout: { type: Number, default: 4000 } }

  connect() {
    if (document.documentElement.hasAttribute("data-turbo-preview")) return
    this.startTimer()
  }

  startTimer() {
    if (this.timeoutValue <= 0) return
    clearTimeout(this._timer)
    this._timer = setTimeout(() => this.close(), this.timeoutValue)
  }

  close() {
    this.element.classList.add("is-leaving")
    this.element.addEventListener("transitionend", () => {
      this.element.remove()
    }, { once: true })
  }

  disconnect() {
    clearTimeout(this._timer)
  }
}
