require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers 

describe 'Proprietário consulta histórico' do

  context 'de todas as atualizações' do
    it 'a partir da página inicial' do
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
      travel_to 7.days.ago
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: '5000')
      travel_back
      portion = dish.portions.last
      portion.update(option_name: 'Especial', value: '6000')
      other_portion = dish.portions.create!(option_name: 'Grande', value: '7000')

      
      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Pizza'
      click_on 'Histórico'

      formated_date_past = I18n.l(7.days.ago, format: "%d/%m/%y")
      formated_date_present = I18n.l(Date.current, format: "%d/%m/%y")
      expect(page).to have_content "Histórico - Pizza"
      within "#portion_#{portion.id}" do
        expect(page).to have_content "Adicionado: #{formated_date_past} - Porção Média | R$ 50,00"
        expect(page).to have_content "Atualizado: #{formated_date_present} - Porção Especial | R$ 60,00"
      end
      within "#portion_#{other_portion.id}" do
        expect(page).to have_content "Adicionado: #{formated_date_present} - Porção Grande | R$ 70,00"
      end
    end

    it 'sem registros no histórico' do
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
      
      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Pizza'
      click_on 'Histórico'

      expect(page).to have_content 'Sem registros no momento'
    end
  end

  context 'de uma porção específica' do
    it 'a partir da tela de detalhes de uma porção' do
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
      travel_to 7.days.ago
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      portion = dish.portions.create!(option_name: 'Média', value: '5000')
      travel_back
      portion = dish.portions.last
      portion.update(option_name: 'Especial', value: '6000')
      other_portion = dish.portions.create!(option_name: 'Grande', value: '7000')


      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Pizza'
      click_on 'Especial - R$ 60,00'

      formated_date_past = I18n.l(7.days.ago, format: "%d/%m/%y")
      formated_date_present = I18n.l(Date.current, format: "%d/%m/%y")
      expect(page).to have_content 'Histórico - Porção Especial'

      expect(page).to have_content "Adicionado: #{formated_date_past} - Porção Média | R$ 50,00"
      expect(page).to have_content "Atualizado: #{formated_date_present} - Porção Especial | R$ 60,00"
      expect(page).not_to have_content "Adicionado: #{formated_date_present} - Porção Grande | R$ 70,00"
    end
  end
end