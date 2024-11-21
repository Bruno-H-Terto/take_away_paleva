import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="zip-code-mask"
export default class extends Controller {
  connect() {
    const zipCodeInputs = document.querySelectorAll('.zip-code-mask');

    zipCodeInputs.forEach(input => {
      input.addEventListener('input', function(event) {
        let zip_code = event.target.value;
        event.target.value = zip_code_format_mask(zip_code);
      });
    });

    function zip_code_format_mask(zip_code){
      zip_code = zip_code.replace(/\D/g, '');
      zip_code = zip_code.replace(/(\d{5})(\d{1,4})/, '$1-$2');
    
      return zip_code;
    }
  }
}
