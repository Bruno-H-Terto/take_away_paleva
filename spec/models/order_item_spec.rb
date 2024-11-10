require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  context '#valid?' do
    it { should belong_to(:order) }

    it 'todos os campos válidos' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      menu = store.menus.create!(name: 'Café da manhã')
      item_menu = ItemMenu.create!(item: drink, menu: menu)

      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860-71')
      order_item = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')

      expect(order_item).to be_valid
    end

    it 'quantidade é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      menu = store.menus.create!(name: 'Café da manhã')
      item_menu = ItemMenu.create!(item: drink, menu: menu)

      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860-71')
      order_item = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: '', observation: 'Ok')

      expect(order_item).not_to be_valid
    end

    it 'descrição é opcional' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      menu = store.menus.create!(name: 'Café da manhã')
      item_menu = ItemMenu.create!(item: drink, menu: menu)

      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860-71')
      order_item = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: '')

      expect(order_item).to be_valid
    end
  end
end
