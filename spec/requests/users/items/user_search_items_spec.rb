require 'rails_helper'

describe 'Usuário realiza busca por items registrados' do
  context 'Owner GET /take_away_stores/search(.:format)' do
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
      drink = store.items.create!(name: 'Suco', description: 'Sabor morango', calories: 15, type: 'Beverage')

      get search_take_away_stores_path, params: { query: 'a' }

      expect(response).to redirect_to new_owner_session_path
    end
  end

  context 'Employee GET /take_away_stores/search(.:format)' do
    it 'não está autorizado' do
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
      drink = store.items.create!(name: 'Suco', description: 'Sabor morango', calories: 15, type: 'Beverage')
      profile = store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.new(name: 'Bob', surname: 'Construtor', register_number: '362.164.860-71',
            email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      get search_take_away_stores_path, params: { query: 'a' }

      expect(response).to redirect_to root_path
    end
  end
end