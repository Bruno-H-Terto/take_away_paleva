require 'rails_helper'

RSpec.describe HistoricalOrder, type: :model do
  context '#valid?' do
    it 'possui criação automática' do
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
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860-71')

      expect(order.historical_orders.count).to eq 1
    end

    it 'sofre atualização conforme o status se altera' do
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
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860-71')
      order.preparing!
      order.done!
      order.finished!

      expect(order.historical_orders.count).to eq 4
      expect(order.historical_orders[0].information).to eq 'Pedido realizado'
      expect(order.historical_orders[1].information).to eq 'Pedido aceito'
      expect(order.historical_orders[2].information).to eq 'Pedido concluído'
      expect(order.historical_orders[3].information).to eq 'Pedido entregue'
    end
  end
end
