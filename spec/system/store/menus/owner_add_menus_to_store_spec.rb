require 'rails_helper'

describe 'Proprietário cria menus' do
  it 'e deve estar autenticado' do
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

    visit root_path

    expect(page).not_to have_content 'Novo Cardápio'
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

    login_as owner, scope: :owner
    visit root_path
    fill_in 'Rótulo', with: 'Fast Food'
    click_on 'Salvar e continuar'

    expect(page).to have_content 'Cardápio Fast Food cadastrado com sucesso!'
    expect(page).to have_content 'Fast Food'
    within '#items' do
      expect(page).to have_content 'Não existem itens disponíveis'
      expect(page).to have_content 'Clique aqui para cadastrar seus produtos'
    end
  end

  it 'só consegue incluir items com porções cadastradas' do
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
    store.items.create!(name: 'Pizza', description: 'Massa italiana com molho a gosto', calories: 70)

    login_as owner, scope: :owner
    visit root_path
    fill_in 'Rótulo', with: 'Fast Food'
    click_on 'Salvar e continuar'

    expect(page).to have_content 'Não existem itens disponíveis'
  end

  it 'e falha ao não incluir o nome' do
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

    login_as owner, scope: :owner
    visit root_path
    fill_in 'Rótulo', with: ''
    click_on 'Salvar e continuar'

    expect(page).to have_content 'Não foi possível cadastrar o seu cardápio'
  end

  it 'e falha ao incluir nome já em uso' do
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
    store.menus.create!(name: 'Fast Food')

    login_as owner, scope: :owner
    visit root_path
    fill_in 'Rótulo', with: 'Fast Food'
    click_on 'Salvar e continuar'

    expect(page).to have_content 'Não foi possível cadastrar o seu cardápio'
    expect(page).to have_content '1 erro localizado'
    expect(page).to have_content 'Rótulo já está em uso'
  end

  it 'e inclui items no cardápio' do
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
    other_dish = store.items.create!(name: 'Hamburguer', description: 'X-Egg', calories: 130, type: 'Dish')
    portion = dish.portions.create!(option_name: 'Média', value: '5000')
    other_portion = other_dish.portions.create!(option_name: 'Grande', value: '7000')

    login_as owner, scope: :owner
    visit root_path
    fill_in 'Rótulo', with: 'Fast Food'
    click_on 'Salvar e continuar'
    select 'Pizza', from: 'Items'
    click_on 'Criar Item do Menu'

    expect(page).to have_content 'Item adicionado com sucesso!'
    within '#menu-details' do
      expect(page).to have_content 'Pizza'
      expect(page).to have_content 'Média | R$ 50,00'
      expect(page).not_to have_content 'Hamburguer'
      expect(page).not_to have_content 'Grande | R$ 70,00'
    end
  end

  it 'e falha ao selecionar items repetidos' do
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
    menu = store.menus.create!(name: 'Fast Food')
    menu.item_menus.create!(item: dish)

    login_as owner, scope: :owner
    visit take_away_store_menu_path(store, menu)
    select 'Pizza', from: 'Items'
    click_on 'Criar Item do Menu'

    expect(page).to have_content 'Não foi possível adicionar seu item ao Menu'
    expect(page).to have_content '1 erro localizado'
    expect(page).to have_content 'Item já está em uso'
    expect(menu.items.count).to eq 1
  end

  it 'e não localiza items cadastrados' do
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
    menu = store.menus.create!(name: 'Fast Food')
    login_as owner, scope: :owner
    visit take_away_store_menu_path(store, menu)

    expect(page).to have_content 'Não existem itens disponíveis'
    expect(page).to have_content 'Clique aqui para cadastrar seus produtos'
  end
end