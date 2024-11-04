require 'rails_helper'

describe 'Proprietário edita sua porção' do
  include ActiveSupport::Testing::TimeHelpers 
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
    dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
    travel_to 7.days.ago do
      portion = dish.portions.create!(option_name: 'Média', value: '5000')
    end
    travel_back
    portion = dish.portions.last
    portion.update(option_name: 'Especial', value: '6000')
    
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus produtos'
    click_on 'Pizza'

    fomated_date_past = I18n.l(7.days.ago, format: "%d/%m/%y")
    formated_date_present = I18n.l(Date.today, format: "%d/%m/%y")
    within '#historic' do
      expect(page).to have_content "Porção Especial"
      expect(page).to have_content "#{fomated_date_past} - Média | R$ 50,00"
      expect(page).to have_content "#{formated_date_present} - Média => Especial | R$ 50,00 => R$ 60,00"
    end
  end
end