export function company_mask(register_number) {
  register_number = register_number.replace(/\D/g, '');

  register_number = register_number.replace(/(\d{2})(\d)/, '$1.$2');
  register_number = register_number.replace(/(\d{3})(\d)/, '$1.$2');
  register_number = register_number.replace(/(\d{3})(\d)/, '$1/$2');
  register_number = register_number.replace(/(\d{4})(\d)/, '$1-$2');

  return register_number;
}

const register_numberInput = document.getElementById('register_number');

register_numberInput.addEventListener('input', function(event) {
  let valorregister_number = event.target.value;
  event.target.value = company_mask(valorregister_number);
});
