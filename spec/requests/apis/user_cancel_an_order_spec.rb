require 'rails_helper'

describe 'Usuário cancela um pedido' do
  context 'PATCH /api/v1/stores/:store_code/orders/:code/canceled' do
    it 'com sucesso' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      drink_portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      menu = store.menus.create!(name: 'Vinhos e Bebidas')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_item = order.order_items.create!(menu: menu, item: drink, portion: drink_portion, quantity: 1, observation: 'Ok')

      patch canceled_api_v1_store_order_path(store.code, order.code), params: { reason: 'Estoque insuficiente' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      formated_date = I18n.l(order.created_at_current, format: "%d/%m/%y - %H:%M")
      expect(json_response['order']['name']).to eq 'Jhon'
      expect(json_response['order']['created_at_current']).to eq formated_date
      expect(json_response['order']['status']).to eq 'canceled'
      expect(json_response['order']['phone_number']).to eq '(11) 999998888'
      expect(json_response['order']['email']).to eq 'jhon@email.com'
      expect(json_response['order']['register_number']).to eq '701.128.250-52'
      expect(json_response['order_items'].length).to eq 1
      expect(json_response['order_items'].first['menu']).to eq 'Vinhos e Bebidas'
      expect(json_response['order_items'].first['item']).to eq 'Vinho tinto'
      expect(json_response['order_items'].first['portion']).to eq 'Pequena - R$ 130,00'
      expect(json_response['order_items'].first['quantity']).to eq 1
      expect(json_response['order_items'].first['observation']).to eq 'Ok'
      expect(Order.last.status).to eq 'canceled'
      reason = order.reason_cancel
      expect(reason.information).to eq 'Estoque insuficiente'
    end

    it 'deve justificar o cancelamento' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      drink_portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      menu = store.menus.create!(name: 'Vinhos e Bebidas')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_item = order.order_items.create!(menu: menu, item: drink, portion: drink_portion, quantity: 1, observation: 'Ok')

      patch canceled_api_v1_store_order_path(store.code, order.code), params: { reason: '' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Deve apresentar a justificava para o cancelamento'
      expect(order.canceled?).to eq false
    end

    it 'não pode cancelar pedidos já cancelados' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      drink_portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      menu = store.menus.create!(name: 'Vinhos e Bebidas')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_item = order.order_items.create!(menu: menu, item: drink, portion: drink_portion, quantity: 1, observation: 'Ok')
      order.canceled!

      patch canceled_api_v1_store_order_path(store.code, order.code), params: { reason: 'Estoque insuficiente' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Status do pedido inválido para o cancelamento'
    end

    it 'não pode cancelar pedidos concluídos' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      drink_portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      menu = store.menus.create!(name: 'Vinhos e Bebidas')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_item = order.order_items.create!(menu: menu, item: drink, portion: drink_portion, quantity: 1, observation: 'Ok')
      order.done!

      patch canceled_api_v1_store_order_path(store.code, order.code), params: { reason: 'Estoque insuficiente' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Status do pedido inválido para o cancelamento'
    end

    it 'não pode cancelar pedidos já entregues' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      drink_portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      menu = store.menus.create!(name: 'Vinhos e Bebidas')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_item = order.order_items.create!(menu: menu, item: drink, portion: drink_portion, quantity: 1, observation: 'Ok')
      order.finished!

      patch canceled_api_v1_store_order_path(store.code, order.code), params: { reason: 'Estoque insuficiente' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Status do pedido inválido para o cancelamento'
    end

    it 'falha ao ter erro interno' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      drink_portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      menu = store.menus.create!(name: 'Vinhos e Bebidas')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_item = order.order_items.create!(menu: menu, item: drink, portion: drink_portion, quantity: 1, observation: 'Ok')
      allow_any_instance_of(Order).to receive(:canceled!).and_raise(ActiveRecord::ActiveRecordError)

      patch canceled_api_v1_store_order_path(store.code, order.code), params: { reason: 'Estoque insuficiente' }

      expect(response.status).to eq 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error_message']).to eq 'Ocorreu um erro interno'
    end

    it 'código do pedido deve pertencer ao Estabelecimento' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      drink_portion = drink.portions.create!(option_name: 'Pequena', value: 13000)
      menu = store.menus.create!(name: 'Vinhos e Bebidas')
      order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_item = order.order_items.create!(menu: menu, item: drink, portion: drink_portion, quantity: 1, observation: 'Ok')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
          email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
          register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
          number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
          email: 'pateltop@email.com')
      order_2 = other_store.orders.create!(name: 'Maria', phone_number: '', email: 'maria@email.com', register_number: '690.814.440-26')

      patch canceled_api_v1_store_order_path(store.code, order_2.code), params: { reason: 'Estoque insuficiente' }

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error_message']).to include 'Recurso não localizado'
    end
  end
end