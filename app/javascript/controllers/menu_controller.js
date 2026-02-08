import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  open() {
    this.panelTarget.classList.remove("-translate-x-full")
  }

  close() {
    this.panelTarget.classList.add("-translate-x-full")
  }
}

