require 'rails_helper'

describe 'Usuário entrega um pedido' do
  context 'Proprietários' do
    it 'deve estar autenticado' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: 7000)
      menu = store.menus.create!(name: 'Fast Food')
      menu.item_menus.create!(item: dish)
      order = store.orders.create!(name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: '362.164.860-71')
      order.order_items.create!(menu: menu, item: dish, portion: portion, quantity: 1, observation: 'Completo' )
      order.preparing!
      order.done!

      patch finished_order_path(order)

      expect(response).to redirect_to root_path
    end

    it 'com sucesso' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: 7000)
      menu = store.menus.create!(name: 'Fast Food')
      menu.item_menus.create!(item: dish)
      order = store.orders.create!(name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: '362.164.860-71')
      order.preparing!
      order.done!

      login_as owner, scope: :owner
      patch finished_order_path(order)

      expect(Order.last.finished?).to eq true
    end

    it 'pedido deve estar concluído' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: 7000)
      menu = store.menus.create!(name: 'Fast Food')
      menu.item_menus.create!(item: dish)
      order = store.orders.create!(name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: '362.164.860-71')
      order.preparing!

      login_as owner, scope: :owner
      patch finished_order_path(order)

      expect(Order.last.finished?).to eq false
    end

    it 'deve ser do próprio Estabelecimento' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: 7000)
      menu = store.menus.create!(name: 'Fast Food')
      menu.item_menus.create!(item: dish)
      order = store.orders.create!(name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: '362.164.860-71')
      order.order_items.create!(menu: menu, item: dish, portion: portion, quantity: 1, observation: 'Completo' )
      order.preparing!
      order.done!
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
          email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
          register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
          number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
          email: 'pateltop@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        other_store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end

      login_as other_owner, scope: :owner
      patch finished_order_path(order)

      expect(response).to redirect_to root_path
      expect(Order.last.finished?).to eq false
    end
  end

  context 'Funcionários' do
    it 'com sucesso' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: 7000)
      menu = store.menus.create!(name: 'Fast Food')
      menu.item_menus.create!(item: dish)
      order = store.orders.create!(name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: '362.164.860-71')
      order.preparing!
      order.done!
      profile = store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Construtor', register_number: '362.164.860-71',
            email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      patch finished_order_path(order)

      expect(Order.last.finished?).to eq true
    end

    it 'deve ser do próprio Estabelecimento' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: 7000)
      menu = store.menus.create!(name: 'Fast Food')
      menu.item_menus.create!(item: dish)
      order = store.orders.create!(name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: '362.164.860-71')
      order.order_items.create!(menu: menu, item: dish, portion: portion, quantity: 1, observation: 'Completo' )
      order.preparing!
      order.done!
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
          email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
          register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
          number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
          email: 'pateltop@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        other_store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      profile = other_store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Construtor', register_number: '362.164.860-71',
            email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      patch finished_order_path(order)

      expect(response).to redirect_to root_path
      expect(Order.last.finished?).to eq false
    end

    it 'pedido deve estar concluído' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: 7000)
      menu = store.menus.create!(name: 'Fast Food')
      menu.item_menus.create!(item: dish)
      order = store.orders.create!(name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: '362.164.860-71')
      order.preparing!
      profile = store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Construtor', register_number: '362.164.860-71',
            email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      patch finished_order_path(order)

      expect(Order.last.finished?).to eq false
    end
  end
end