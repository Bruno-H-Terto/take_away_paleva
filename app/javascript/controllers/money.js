export function money_mask(money) {
  money = money.replace(/\D/g, '');
  money = money.replace(/(\d{2})$/, ',$1');
  money = money.replace(/\B(?=(\d{3})+(?!\d))/g, '.');

  return money;
}
