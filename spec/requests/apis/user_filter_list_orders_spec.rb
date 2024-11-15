require 'rails_helper'

describe 'Listagem de pedidos do mais antigo ao mais recente de um Estabelecimento a partir de seu código' do
  context 'GET /api/v1/stores/:store_code/orders' do
    it 'com sucesso' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order_1 = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_2 = store.orders.create!(name: 'José', phone_number: '(21) 988887777', email: '', register_number: '')
      order_3 = store.orders.create!(name: 'Maria', phone_number: '', email: 'maria@email.com', register_number: '690.814.440-26')
      order_4 = store.orders.create!(name: 'Ana', phone_number: '', email: 'ana@email.com', register_number: '')

      get api_v1_store_orders_path(store.code)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 4
      expect(json_response[0].keys).to include "id"
      expect(json_response[0].keys).to include "name"
      expect(json_response[0].keys).to include "code"
      expect(json_response[0].keys).to include "status"
      expect(json_response[0].keys).to include "created_at_current"
      expect(json_response[0].keys).to include "take_away_store_id"
      expect(json_response[0].keys).not_to include 'created_at'
      expect(json_response[0].keys).not_to include 'updated_at'
      expect(json_response[0].keys).not_to include "phone_number"
      expect(json_response[0].keys).not_to include "register_number"
      expect(json_response[0].keys).not_to include "email"
      expect(json_response[0]['name']).to eq 'Jhon'
      expect(json_response[0]['code']).to eq order_1.code
      expect(json_response[1]['name']).to eq 'José'
      expect(json_response[1]['code']).to eq order_2.code
      expect(json_response[2]['name']).to eq 'Maria'
      expect(json_response[2]['code']).to eq order_3.code
      expect(json_response[3]['name']).to eq 'Ana'
      expect(json_response[3]['code']).to eq order_4.code
    end

    it 'só tem acesso a listagem do Estabelecimento procurado' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order_1 = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
          email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
          register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
          number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
          email: 'pateltop@email.com')
      order_2 = other_store.orders.create!(name: 'Maria', phone_number: '', email: 'maria@email.com', register_number: '690.814.440-26')

      get api_v1_store_orders_path(store.code)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 1
      expect(json_response.first.values).to include 'Jhon'
      expect(json_response.first.values).to include order_1.code
      expect(json_response.last.values).not_to include 'Maria'
      expect(json_response.last.values).not_to include order_2.code
    end

    it 'e falha ao passar um Estabelecimento inexistente' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order_1 = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')

      get api_v1_store_orders_path(99999)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to include 'error_message'
      expect(json_response['error_message']).to include 'Recurso não localizado'
    end

    it 'e falha ao sofrer um erro interno' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order_1 = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_2 = store.orders.create!(name: 'José', phone_number: '(21) 988887777', email: '', register_number: '')
      order_3 = store.orders.create!(name: 'Maria', phone_number: '', email: 'maria@email.com', register_number: '690.814.440-26')
      order_4 = store.orders.create!(name: 'Ana', phone_number: '', email: 'ana@email.com', register_number: '')
      allow_any_instance_of(TakeAwayStore).to receive(:orders).and_raise(ActiveRecord::ActiveRecordError)

      get api_v1_store_orders_path(store.code)

      expect(response.status).to eq 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.keys).to include 'error_message'
      expect(json_response['error_message']).to include 'Ocorreu um erro interno'
    end
  end

  context 'GET /api/v1/stores/:store_code/orders/status' do
    it 'com sucesso' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order_1 = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_2 = store.orders.create!(name: 'José', phone_number: '(21) 988887777', email: '', register_number: '')
      order_3 = store.orders.create!(name: 'Maria', phone_number: '', email: 'maria@email.com', register_number: '690.814.440-26')
      order_3.preparing!
      order_4 = store.orders.create!(name: 'Ana', phone_number: '', email: 'ana@email.com', register_number: '')
      order_4.canceled!

      get status_api_v1_store_orders_path(store.code), params: { status: 'waiting_confirmation' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response.inspect).to include 'Jhon'
      expect(json_response.inspect).to include order_1.code
      expect(json_response.inspect).to include 'José'
      expect(json_response.inspect).to include order_2.code
      expect(json_response.inspect).not_to include 'Maria'
      expect(json_response.inspect).not_to include order_3.code
      expect(json_response.inspect).not_to include 'Ana'
      expect(json_response.inspect).not_to include order_4.code
    end

    it 'informa status inexistente' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order_1 = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_2 = store.orders.create!(name: 'José', phone_number: '(21) 988887777', email: '', register_number: '')
      order_3 = store.orders.create!(name: 'Maria', phone_number: '', email: 'maria@email.com', register_number: '690.814.440-26')
      order_3.preparing!
      order_4 = store.orders.create!(name: 'Ana', phone_number: '', email: 'ana@email.com', register_number: '')
      order_4.canceled!

      get status_api_v1_store_orders_path(store.code), params: { status: 'kamehameha' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 4
      expect(json_response.inspect).to include 'Jhon'
      expect(json_response.inspect).to include order_1.code
      expect(json_response.inspect).to include 'José'
      expect(json_response.inspect).to include order_2.code
      expect(json_response.inspect).to include 'Maria'
      expect(json_response.inspect).to include order_3.code
      expect(json_response.inspect).to include 'Ana'
      expect(json_response.inspect).to include order_4.code
    end

    it 'informa status vazio' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order_1 = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_2 = store.orders.create!(name: 'José', phone_number: '(21) 988887777', email: '', register_number: '')
      order_3 = store.orders.create!(name: 'Maria', phone_number: '', email: 'maria@email.com', register_number: '690.814.440-26')
      order_3.preparing!
      order_4 = store.orders.create!(name: 'Ana', phone_number: '', email: 'ana@email.com', register_number: '')
      order_4.canceled!

      get status_api_v1_store_orders_path(store.code), params: { status: '' }

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 4
      expect(json_response.inspect).to include 'Jhon'
      expect(json_response.inspect).to include order_1.code
      expect(json_response.inspect).to include 'José'
      expect(json_response.inspect).to include order_2.code
      expect(json_response.inspect).to include 'Maria'
      expect(json_response.inspect).to include order_3.code
      expect(json_response.inspect).to include 'Ana'
      expect(json_response.inspect).to include order_4.code
    end

    it 'sofre erro interno' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      order_1 = store.orders.create!(name: 'Jhon', phone_number: '(11) 999998888', email: 'jhon@email.com', register_number: '701.128.250-52')
      order_2 = store.orders.create!(name: 'José', phone_number: '(21) 988887777', email: '', register_number: '')
      order_3 = store.orders.create!(name: 'Maria', phone_number: '', email: 'maria@email.com', register_number: '690.814.440-26')
      order_3.preparing!
      order_4 = store.orders.create!(name: 'Ana', phone_number: '', email: 'ana@email.com', register_number: '')
      order_4.canceled!
      allow_any_instance_of(TakeAwayStore).to receive(:orders).and_raise(ActiveRecord::ActiveRecordError)

      get status_api_v1_store_orders_path(store.code), params: { status: 'kamehameha' }

      expect(response.status).to eq 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error_message']).to eq 'Ocorreu um erro interno'
    end
  end
end