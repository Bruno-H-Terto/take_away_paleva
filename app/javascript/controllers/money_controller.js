import { Controller } from "@hotwired/stimulus"
import { money_mask } from "./money";

// Connects to data-controller="money"
export default class extends Controller {
  connect() {
    const moneyInputs = document.querySelectorAll('.money');

    moneyInputs.forEach(input => {
      input.addEventListener('input', function(event) {
        let money = event.target.value;
        event.target.value = money_mask(money);
      });
    });
  }
}
