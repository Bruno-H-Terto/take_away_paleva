require 'rails_helper'

describe 'Usuário registra uma nova tag' do
  context 'Owner POST /take_away_stores/:take_away_store_id/items/:item_id/tags' do
    it 'deve estar autenticado' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pastel Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')

      post take_away_store_item_tags_path(store, drink), params: {characteristic: 'Alcoólico'}

      expect(response).to redirect_to new_owner_session_path
    end

    it 'só tem acesso a tags da própria loja' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pastel Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
          email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
          register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
          number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
          email: 'pateltop@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        other_store.business_hours.create!(day_of_week: key, status: :open, open_time: '10:00',
            close_time: '18:00')
      end

      login_as other_owner, scope: :owner
      post take_away_store_item_tags_path(store, drink), params: {characteristic: 'Alcoólico'}

      expect(response).to redirect_to take_away_store_path(other_store)
      expect(Tag.count).to eq 0
    end
  end

  context 'Employee POST /take_away_stores/:take_away_store_id/items/:item_id/tags' do
    it 'não autorizado' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pastel Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
        store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
            close_time: '17:00')
      end
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')
      profile = store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.new(name: 'Bob', surname: 'Construtor', register_number: '362.164.860-71',
            email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      post take_away_store_item_tags_path(store, drink), params: {characteristic: 'Alcoólico'}

      expect(response).to redirect_to root_path
    end
  end
end