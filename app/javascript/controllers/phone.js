export function phone_format_mask(phone) {
  phone = phone.replace(/\D/g, '');

  if (phone.length > 10) {
    phone = phone.replace(/^(\d{2})(\d{5})(\d{4})$/, '($1) $2-$3');
  } else if (phone.length > 9) {
    phone = phone.replace(/^(\d{2})(\d{4})(\d{4})$/, '($1) $2-$3');
  } else if (phone.length > 7) {
    phone = phone.replace(/^(\d{2})(\d{4})(\d{1,3})$/, '($1) $2-$3');
  } else if (phone.length > 5) {
    phone = phone.replace(/^(\d{2})(\d{4,5})$/, '($1) $2');
  } else if (phone.length > 2) {
    phone = phone.replace(/^(\d{2})(\d{0,4})$/, '($1) $2');
  } else {
    phone = phone.replace(/^(\d{0,2})$/, '($1');
  }

  return phone;
}
