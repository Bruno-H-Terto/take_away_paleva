require 'rails_helper'

describe 'Proprietário edita preço de sua porção' do
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
    portion = dish.portions.create!(option_name: 'Média', description: '4 pessoas', value: '5000')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus produtos'
    click_on 'Pizza'
    click_on 'Média - R$ 50,00'

    expect(page).to have_content 'Pizza - porção Média'
    formated_date = I18n.l(portion.created_at, format: "%d/%m/%y")
    expect(page).to have_content "Valor cadastrado em #{formated_date}"
    expect(page).to have_button 'Atualizar Porção'
  end
end