require 'rails_helper'

describe 'Usuário vê detalhes do Estabelecimento' do
  context 'GET api/v1/stores' do
    it 'vê listagem de Estabelecimentos' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
          email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
          register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
          number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
          email: 'pasteltop@email.com')

      get api_v1_stores_path

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['stores'].inspect).not_to include 'created_at'
      expect(json_response['store'].inspect).not_to include 'updated_at'
      expect(json_response['stores'].inspect).not_to include 'register_number'
      expect(json_response['stores'].inspect).not_to include 'district'
      expect(json_response['stores'].inspect).not_to include 'city'
      expect(json_response['stores'].inspect).not_to include 'state'
      expect(json_response['stores'].inspect).not_to include 'zip_code'
      expect(json_response['stores'].inspect).not_to include 'complement'
      expect(json_response['stores'].first['trade_name']).to eq 'Grifinória'
      expect(json_response['stores'].first['corporate_name']).to eq 'Hogwarts LTDA'
      expect(json_response['stores'].first['code']).to eq store.code
      expect(json_response['stores'].first['email']).to eq 'potter@email.com'
      expect(json_response['stores'].last['trade_name']).to eq 'Pastelaria Top'
      expect(json_response['stores'].last['corporate_name']).to eq 'Pastel LTDA'
      expect(json_response['stores'].last['code']).to eq other_store.code
      expect(json_response['stores'].last['email']).to eq 'pasteltop@email.com'
    end

    it 'não localiza Estabelecimentos cadastrados' do
      get api_v1_stores_path

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['stores']).to eq 'Não foram localizados Estabelecimento registrados'
    end

    it 'sofre com erro interno' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
          email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
          register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
          number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
          email: 'pasteltop@email.com')
      allow(TakeAwayStore).to receive(:all).and_raise(ActiveRecord::ActiveRecordError)
      get api_v1_stores_path

      expect(response.status).to eq 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error_message']).to eq 'Ocorreu um erro interno'
    end
  end

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