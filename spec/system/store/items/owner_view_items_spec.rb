require 'rails_helper'

describe 'Proprietário acesso área de produtos' do
  it 'com sucesso' do
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
    store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
    store.items.create!(name: 'Hamburguer', description: 'Artesanal', calories: 100, type: 'Dish').inactive!
    store.items.create!(name: 'Coca-Cola', description: 'Zero açucar', calories: 30, type: 'Beverage')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus produtos'

    expect(page).to have_content 'Gerencie seu estoque e cadastre seus produtos para venda'
    expect(page).to have_content 'Nota: Itens inativos não são adicionados ao seu cardápio'
    expect(page).to have_content 'Pizza'
    expect(page).to have_content 'Hamburguer'
    expect(page).to have_content 'Coca-Cola'
  end
end