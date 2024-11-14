require 'rails_helper'

describe 'Usuário vê listagem de pedidos' do
  context 'GET /api/v1/orders' do
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

      get api_v1_store_orders_path(store)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 4
      expect(json_response[0].keys).to include "id"
      expect(json_response[0].keys).to include "name"
      expect(json_response[0].keys).to include "code"
      expect(json_response[0].keys).to include "status"
      expect(json_response[0].keys).to include "take_away_store_id"
      expect(json_response[0].keys).to include "created_at_current"
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
  end
end