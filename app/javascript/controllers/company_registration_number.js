export function company_mask(register_number) {
  register_number = register_number.replace(/\D/g, '');

  register_number = register_number.replace(/(\d{2})(\d)/, '$1.$2');
  register_number = register_number.replace(/(\d{3})(\d)/, '$1.$2');
  register_number = register_number.replace(/(\d{3})(\d)/, '$1/$2');
  register_number = register_number.replace(/(\d{4})(\d)/, '$1-$2');

  return register_number;
}

const register_numberInput = document.querySelector('.company_register_number');

if (register_numberInput) {
  register_numberInput.addEventListener('input', function(event) {
    let register_number = event.target.value;
    event.target.value = company_mask(register_number);
  });
}
