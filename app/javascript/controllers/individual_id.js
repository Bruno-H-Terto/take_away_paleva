export function individual_register_number_mask(register_number) {
  register_number = register_number.replace(/\D/g, '');

  register_number = register_number.replace(/(\d{3})(\d)/, '$1.$2');
  register_number = register_number.replace(/(\d{3})(\d)/, '$1.$2');
  register_number = register_number.replace(/(\d{3})(\d)/, '$1-$2');

  return register_number;
}

