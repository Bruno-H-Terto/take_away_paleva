require 'rails_helper'

describe 'Proprietário edita sua porção' do
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
    portion = dish.portions.create!(option_name: 'Média', value: '5000')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus produtos'
    click_on 'Pizza'
    click_on 'Média - R$ 50,00'

    expect(page).to have_content 'Pizza - porção Média'
    formated_date = I18n.l(portion.created_at, format: "%d/%m/%y")
    expect(page).to have_content "Porção cadastrada em #{formated_date}"
    expect(page).to have_content 'Valor atual: R$ 50,00'
    expect(page).to have_field 'Opção'
    expect(page).to have_field 'Preço'
    expect(page).to have_button 'Atualizar Porção'
  end

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
    dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
    portion = dish.portions.create!(option_name: 'Média', value: '5000')

    login_as owner, scope: :owner
    visit portion_path(portion)
    fill_in 'Opção', with: 'Promação'
    fill_in 'Preço', with: '4200'
    click_on 'Atualizar Porção'

    expect(page).to have_content 'Porção atualizada com sucesso!'
    expect(page).to have_content 'Valor atual: R$ 42,00'
  end

  it 'e falha ao não incluir informações obrigatórias' do
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
    portion = dish.portions.create!(option_name: 'Média', value: '5000')

    login_as owner, scope: :owner
    visit portion_path(portion)
    fill_in 'Opção', with: ''
    fill_in 'Preço', with: ''
    click_on 'Atualizar Porção'

    expect(page).to have_content 'Não foi possível atualizar sua porção'
    expect(page).to have_content 'Valor atual: R$ 50,00'
  end

  it 'somente está autorizado a editar porções do próprio estabelecimento' do
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
    portion = dish.portions.create!(option_name: 'Média', value: '5000')
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
    visit portion_path(portion)

    expect(page).to have_content 'Acesso não autorizado'
    expect(current_path).to eq root_path
  end
end