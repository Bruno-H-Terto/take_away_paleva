require 'rails_helper'

describe 'Usuário visualiza detalhes de um pedido' do
  context 'GET /api/v1/stores/:store_code/orders/:code' do
    it 'com sucesso' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      drink_portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      dish = store.items.create!(name: 'Misto quente', description: 'Na chapa', calories: 70, type: 'Dish')
      dish_portion = dish.portions.create!(option_name: 'Média', value: 8000)
      first_menu = store.menus.create!(name: 'Vinhos e Bebidas')
      other_menu = store.menus.create!(name: 'Café da manhã')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_item_1 = order.order_items.create!(menu: first_menu, item: drink, portion: drink_portion, quantity: 1, observation: 'Ok')
      order_item_2 = order.order_items.create!(menu: other_menu, item: dish, portion: dish_portion, quantity: 2, observation: '')

      get api_v1_store_order_path(store.code, order.code)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      formated_date = I18n.l(order.created_at_current, format: "%d/%m/%y - %H:%M")
      expect(json_response['order']['name']).to eq 'Jhon'
      expect(json_response['order']['created_at_current']).to eq formated_date
      expect(json_response['order']['status']).to eq 'waiting_confirmation'
      expect(json_response['order']['phone_number']).to eq '(11) 999998888'
      expect(json_response['order']['email']).to eq 'jhon@email.com'
      expect(json_response['order']['register_number']).to eq '701.128.250-52'
      expect(json_response['order_items'].length).to eq 2
      expect(json_response['order_items'].first['menu']).to eq 'Vinhos e Bebidas'
      expect(json_response['order_items'].first['item']).to eq 'Vinho tinto'
      expect(json_response['order_items'].first['portion']).to eq 'Pequena - R$ 130,00'
      expect(json_response['order_items'].first['quantity']).to eq 1
      expect(json_response['order_items'].first['observation']).to eq 'Ok'
      expect(json_response['order_items'].last['menu']).to eq 'Café da manhã'
      expect(json_response['order_items'].last['item']).to eq 'Misto quente'
      expect(json_response['order_items'].last['portion']).to eq 'Média - R$ 80,00'
      expect(json_response['order_items'].last['quantity']).to eq 2
      expect(json_response['order_items'].last['observation']).to eq 'Nenhuma'
    end

    it 'pedido não possui itens' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')

      get api_v1_store_order_path(store.code, order.code)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      fomated_date = I18n.l(order.created_at_current, format: "%d/%m/%y - %H:%M")
      expect(json_response['order']['name']).to eq 'Jhon'
      expect(json_response['order']['created_at_current']).to eq fomated_date
      expect(json_response['order']['status']).to eq 'waiting_confirmation'
      expect(json_response['order']['phone_number']).to eq '(11) 999998888'
      expect(json_response['order']['email']).to eq 'jhon@email.com'
      expect(json_response['order']['register_number']).to eq '701.128.250-52'
      expect(json_response['order_items']['message']).to eq 'Sem itens registrados'
    end

    it 'informa código de pedido inválido' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')

      get api_v1_store_order_path(store.code, 999999)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error_message']).to include 'Recurso não localizado'
    end

    it 'código do pedido deve pertencer ao Estabelecimento' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
          email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
          register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
          number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
          email: 'pateltop@email.com')
      order_2 = other_store.orders.create!(name: 'Maria', phone_number: '', email: 'maria@email.com', register_number: '690.814.440-26')

      get api_v1_store_order_path(store.code, order_2.code)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error_message']).to include 'Recurso não localizado'
    end
  end
end