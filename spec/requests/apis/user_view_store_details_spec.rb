require 'rails_helper'

describe 'Usuário vê detalhes do Estabelecimento' do
  context 'GET api/v1/stores/:code' do
    it 'com sucesso' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')

      get api_v1_store_path(store.code)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['store'].keys).not_to include 'created_at'
      expect(json_response['store'].keys).not_to include 'updated_at'
      expect(json_response['store']['trade_name']).to eq 'Grifinória'
      expect(json_response['store']['corporate_name']).to eq 'Hogwarts LTDA'
      expect(json_response['store']['register_number']).to eq '76.898.265/0001-10'
      expect(json_response['store']['district']).to eq 'Bolsão'
      expect(json_response['store']['city']).to eq 'Hogsmeade'
      expect(json_response['store']['state']).to eq 'SP'
      expect(json_response['store']['zip_code']).to eq '11000-000'
      expect(json_response['store']['complement']).to eq ''
      expect(json_response['store']['email']).to eq 'potter@email.com'
    end

    it 'sofre erro interno' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      allow(TakeAwayStore).to receive(:find_by!).and_raise(ActiveRecord::ActiveRecordError)

      get api_v1_store_path(store.code)

      expect(response.status).to eq 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error_message']).to eq 'Ocorreu um erro interno'
    end

    it 'informa código inexistente' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')

      get api_v1_store_path(999999)

      expect(response.status).to eq 404
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error_message']).to eq 'Recurso não localizado'
    end
  end
end