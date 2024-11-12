require 'rails_helper'

describe 'Usuário confirma um pedido' do
  context 'Owner POST /orders' do
    it 'deve estar autenticado' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: '5000')
      menu = store.menus.create!(name: 'Fast Food')

      post orders_path, params: { order: { name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: ''} }

      expect(response).to redirect_to root_path
      expect(Order.count).to eq 0
    end

    it 'deve ser do próprio estabelecimento' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: '5000')
      menu = store.menus.create!(name: 'Fast Food')
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
      allow_any_instance_of(OrdersController).to receive(:session).and_return({
        cart_items: [
          { menu: menu.id, item: dish.id, portion_id: portion.id, observation: 'Completo', quantity: '1' }
        ]
      })

      login_as other_owner, scope: :owner
      post orders_path, params: { order: { name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: ''} }

      expect(Order.count).to eq 0
      expect(OrderItem.count).to eq 0
    end
  end
end
