import { Controller } from "@hotwired/stimulus"

// data-controller="avatar-preview" で使用
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
