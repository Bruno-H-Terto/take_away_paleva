require 'rails_helper'

describe 'Proprietário consulta histórico' do
  include ActiveSupport::Testing::TimeHelpers 
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
      dish.update(name: 'Pizza de Calabresa')
      portion = dish.portions.last
      portion.update(option_name: 'Especial', value: '6000')
      dish.portions.create!(option_name: 'Grande', value: '7000')

      
      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Pizza'
      click_on 'Histórico'

      formated_date_past = I18n.l(7.days.ago, format: "%d/%m/%y")
      formated_date_present = I18n.l(Date.today, format: "%d/%m/%y")
      within '#historic' do
        expect(page).to have_content 'Histórico'
        expect(page).to have_content "#{formated_date_past} - Item Pizza adicionado"
        expect(page).to have_content "#{formated_date_past} - Porção Média | R$ 50,00 adicionado"
        expect(page).to have_content "#{formated_date_present} - Atualização: Pizza => Pizza de Calabresa"
        expect(page).to have_content "#{formated_date_present} - Atualização: Média => Especial | R$ 50,00 => R$ 60,00"
        expect(page).to have_content "#{formated_date_past} - Porção Grande | R$ 70,00 adicionado"
      end
    end
  end
end