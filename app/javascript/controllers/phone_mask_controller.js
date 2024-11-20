import { Controller } from "@hotwired/stimulus"
import { phone_format_mask } from "./phone";

// Connects to data-controller="phone-mask"
export default class extends Controller {
  connect() {
    const phoneInputs = document.querySelectorAll('.phone-mask');

    phoneInputs.forEach(input => {
      input.addEventListener('input', function(event) {
        let phone = event.target.value;
        event.target.value = phone_format_mask(phone);
      });
    });
  }
}
