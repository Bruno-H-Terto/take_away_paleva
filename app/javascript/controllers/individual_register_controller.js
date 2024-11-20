import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="individual-register"
export default class extends Controller {
  connect() {
    const registerNumberInputs = document.querySelectorAll('.individual_register_number');

    registerNumberInputs.forEach(input => {
      input.addEventListener('input', function(event) {
        let register_number = event.target.value;
        event.target.value = individual_register_number_mask(register_number);
      });
    });
  }
}
