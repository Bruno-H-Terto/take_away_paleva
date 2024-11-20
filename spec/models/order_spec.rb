require 'rails_helper'

RSpec.describe Order, type: :model do
  context '#valid?' do
    it { belong_to(:take_away_store) }
    it { have_many(:order_items) }

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

      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860-71')
      order_items = order.order_items.create!(menu: menu, item: drink, portion: portion, quantity: 2, observation: 'Ok')
      
      expect(order).to be_valid
      expect(order.total).to eq 26000
    end

    it 'data é gerada automaticamente com o pedido' do
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
      order_items = order.order_items.create!(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')
      
      expect(I18n.l(order.created_at_current, format: "%d/%m/%y - %H:%M")).to eq I18n.l(Time.current, format: "%d/%m/%y - %H:%M")
    end

    it 'status para novos pedidos deve ser aguardando confirmação' do
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

      order = store.orders.build(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860-71')
      order_items = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')

      expect(order.waiting_confirmation?).to be_truthy
    end

    it 'pedido deve ter um código gerado automáticamente' do
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
      order_items = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')
      
      expect(order.code.present?).to be_truthy
      expect(order.code).to eq 'ABCD1234'
    end

    it 'nome é obrigatório' do
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

      order = store.orders.build(name: '', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860-71')
      order_items = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')
      
      expect(order).not_to be_valid
    end

    it 'telefone é opcional se email está presente' do
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

      order = store.orders.build(name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: '362.164.860-71')
      order_items = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')
      
      expect(order).to be_valid
    end

    it 'email deve ser válido se informado' do
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

      order = store.orders.build(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email', register_number: '362.164.860-71')
      order_items = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')
      
      expect(order).not_to be_valid
    end

    it 'email é opcional se telefone está presente' do
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

      order = store.orders.build(name: 'Jhon', phone_number: '(11) 999887744', email: '', register_number: '362.164.860-71')
      order_items = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')
      
      expect(order).to be_valid
    end

    it 'telefone deve ser válido se informado' do
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

      order = store.orders.build(name: 'Jhon', phone_number: '(11) 999887', email: 'jhon@email.com', register_number: '362.164.860-71')
      order_items = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')
      
      expect(order).not_to be_valid
    end

    it 'telefone ou email deve estar presente' do
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

      order = store.orders.build(name: 'Jhon', phone_number: '', email: '', register_number: '362.164.860-71')
      order_items = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')
      
      expect(order).not_to be_valid
    end

    it 'CPF é opcional' do
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

      order = store.orders.build(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '')
      order_items = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')
      
      expect(order).to be_valid
    end

    it 'CPF deve ser válido se informado' do
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

      order = store.orders.build(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860')
      order_items = order.order_items.build(menu: menu, item: drink, portion: portion, quantity: 1, observation: 'Ok')
      
      expect(order).not_to be_valid
    end
  end
end
