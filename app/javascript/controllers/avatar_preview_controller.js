import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  update() {
    const file = this.inputTarget.files?.[0]
    if (!file) return

    const url = URL.createObjectURL(file)
    const img = this.element.querySelector(".preview-target")
    if (img) img.src = url
  }
}
