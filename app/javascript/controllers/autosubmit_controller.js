import { Controller } from "@hotwired/stimulus"

// Submits the surrounding form automatically (with a small debounce)
// whenever an input changes, e.g. for live search/filter forms that
// target a Turbo Frame.
export default class extends Controller {
  static values = { delay: { type: Number, default: 300 } }

  submit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.element.requestSubmit(), this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
