require 'rails_helper'

describe 'Proprietário adiciona marcadores' do
  it 'a partir da tela de detalhes' do
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
    store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus produtos'
    click_on 'Vinho tinto'
    click_on 'Nova tag'
    fill_in 'Marcador', with: 'Alcoólica'
    click_on 'Criar Marcador'

    expect(page).to have_content 'Marcador adicionado com sucesso!'
    expect(page).to have_content 'Alcoólica'
  end

  it 'multiplas vezes' do
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
    item = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')
    store.characteristics.create!(quality_name: 'Salgado')
    characteristic = item.characteristics.create!(quality_name: 'Doce', take_away_store: store)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus produtos'
    click_on 'Vinho tinto'
    click_on 'Nova tag'
    fill_in 'Marcador', with: 'Alcoólica'
    click_on 'Criar Marcador'

    expect(page).to have_content 'Marcador adicionado com sucesso!'
    within '#item-details' do
      expect(page).to have_content 'Alcoólica'
      expect(page).to have_content 'Doce'
      expect(page).not_to have_content 'Salgado'
    end
  end

  it 'seleciona uma tag já existente' do
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
    item = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')
    store.characteristics.create!(quality_name: 'Salgado')
    store.characteristics.create!(quality_name: 'Doce')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus produtos'
    click_on 'Vinho tinto'
    select 'Salgado', from: 'characteristic_characteristic_id'
    click_on 'Adicionar Tag'

    expect(page).to have_content 'Marcador adicionado com sucesso!'
    within '#item-details' do
      expect(page).to have_content 'Salgado'
      expect(page).not_to have_content 'Doce'
    end
  end

  it 'só tem acesso a tags criadas pelo próprio Estabelecimento' do
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
    item = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')
    other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
        email: 'jhon@email.com', password: 'treina_dev13')
    other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
        register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
        number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
        email: 'pateltop@email.com')
    other_store.characteristics.create!(quality_name: 'Salgado')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus produtos'
    click_on 'Vinho tinto'

    expect(page).not_to have_select 'characteristic_characteristic_id', options: ['Salgado']
  end

  it 'só tem a opção de cadastrar uma nova caso não exista nenhuma disponível' do
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
    item = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus produtos'
    click_on 'Vinho tinto'

    expect(page).not_to have_select 'characteristic_characteristic_id'
    expect(page).not_to have_button 'Adicionar Tag'
    expect(page).to have_content 'Nenhuma característica disponível. Crie uma nova tag abaixo.'
    expect(page).to have_link 'Nova tag'
  end

  it 'falha ao não preencher valor' do
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
    store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus produtos'
    click_on 'Vinho tinto'
    click_on 'Nova tag'
    fill_in 'Marcador', with: ''
    click_on 'Criar Marcador'

    expect(page).to have_content 'Não foi possível adicionar seu marcador'
    expect(page).to have_content 'Marcador não pode ficar em branco'
  end
end