import { Controller } from "@hotwired/stimulus"
import { company_mask } from "./company_registration_number";

// Connects to data-controller="company-register"
export default class extends Controller {
  connect() {
    const registerNumberInputs = document.querySelectorAll('.company_register_number');

    registerNumberInputs.forEach(input => {
      input.addEventListener('input', function(event) {
        let register_number = event.target.value;
        event.target.value = company_mask(register_number);
      });
    });
  }
}
