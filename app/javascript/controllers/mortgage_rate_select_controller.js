import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [ "durationInput", "interestRateInput" ]
  static values = { rate30: Number, rate15: Number }

  connect() {
    this.sync()
  }

  sync() {
    const rate = this.#selectedDuration == "30" ? this.rate30Value : this.rate15Value

    // A missing FRED rate reads as 0, so keep the rate already in the field
    if (rate) this.interestRateInputTarget.value = rate
  }

  get #selectedDuration() {
    return this.durationInputTarget.value
  }
}
