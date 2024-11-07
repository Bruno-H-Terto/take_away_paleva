require 'rails_helper'

describe 'Proprietário acesso listagem de tags registradas' do
  it 'e vê listagem completa' do
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
    store.characteristics.create!(quality_name: 'Doce')
    store.characteristics.create!(quality_name: 'Salgado')
    store.characteristics.create!(quality_name: 'Vegano')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus marcadores'

    expect(page).to have_content 'Gerencie seus marcadores'
    expect(page).to have_content 'Doce'
    expect(page).to have_content 'Salgado'
    expect(page).to have_content 'Vegado'
  end
end