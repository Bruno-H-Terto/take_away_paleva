require 'rails_helper'

describe 'Prevenção de acessos multíplos a aplicação' do
  context 'de Proprietário para Funcionário' do
    it 'login' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
        close_time: '17:00')
      end
      store.menus.create!(name: 'Café da manhã')
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as owner, scope: :owner
      visit new_employee_session_path

      expect(current_path).to eq root_path
      expect(page).to have_content 'Login já realizado'
    end

    it 'sign up' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
        close_time: '17:00')
      end
      store.menus.create!(name: 'Café da manhã')
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as owner, scope: :owner
      visit new_employee_registration_path

      expect(current_path).to eq root_path
      expect(page).to have_content 'Login já realizado'
    end
  end

  context 'de Funcionário para Proprietário' do
    it 'login' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
        close_time: '17:00')
      end
      store.menus.create!(name: 'Café da manhã')
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit new_owner_session_path

      expect(current_path).to eq root_path
      expect(page).to have_content 'Login já realizado'
    end

    it 'sign up' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
        close_time: '17:00')
      end
      store.menus.create!(name: 'Café da manhã')
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit new_owner_registration_path

      expect(current_path).to eq root_path
      expect(page).to have_content 'Login já realizado'
    end
  end
end