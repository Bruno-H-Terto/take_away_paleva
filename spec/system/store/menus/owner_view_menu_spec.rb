require 'rails_helper'

describe 'Proprietário consulta seus menus' do
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
    dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
    portion = dish.portions.create!(option_name: 'Média', value: '5000')
    menu = store.menus.create!(name: 'Fast Food')

    visit take_away_store_menu_path(store, menu)

    expect(current_path).to eq new_owner_session_path
  end

  it 'e vê listagem de cardápios e seus itens a partir da página inicial' do
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
    store.menus.create!(name: 'Café da manhã')
    store.menus.create!(name: 'Açai')
    store.menus.create!(name: 'Comida da Roça')
    menu = store.menus.create!(name: 'Fast Food')
    menu.item_menus.create!(item: dish)

    login_as owner, scope: :owner
    visit root_path

    expect(page).to have_content 'Café da manhã'
    expect(page).to have_content 'Açai'
    expect(page).to have_content 'Comida da Roça'
    within "#menu_#{menu.id}" do
      expect(page).to have_content 'Fast Food'
      expect(page).to have_content 'Pizza'
    end
  end

  it 'e não possui itens registrados no cardápio' do
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
    menu = store.menus.create!(name: 'Fast Food')


    login_as owner, scope: :owner
    visit root_path

    within "#menu_#{menu.id}" do
      expect(page).to have_content 'Nenhum item cadastrado'
    end
  end

  it 'e não possui cardápios cadastrados' do
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

    expect(page).to have_content 'Não existem cardápios cadastrados'
  end

  it 'e só consegue ter acessso a itens ativos' do
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
    dish.inactive!
    menu = store.menus.create!(name: 'Fast Food')
    menu.item_menus.create!(item: dish)

    login_as owner, scope: :owner
    visit root_path

    within "#menu_#{menu.id}" do
      expect(page).to have_content 'Fast Food'
      expect(page).not_to have_content 'Pizza'
    end
  end

  it 'e visualiza detalhes de um cardápio a partir da página inicial' do
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
    visit root_path
    click_on 'Fast Food'

    expect(page).to have_content 'Pizza'
    expect(page).to have_content 'Média | R$ 50,00'
  end

  it 'e visualiza pratos ativos e inativos' do
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
    other_dish = store.items.create!(name: 'Hamburguer', description: 'Artesanal', calories: 80, type: 'Dish')
    other_dish.inactive!
    portion = dish.portions.create!(option_name: 'Média', value: '5000')
    menu = store.menus.create!(name: 'Fast Food')
    menu.item_menus.create!(item: dish)
    menu.item_menus.create!(item: other_dish)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Fast Food'

    expect(page).to have_content 'Pizza'
    expect(page).to have_content 'Média | R$ 50,00'
    expect(page).to have_content 'Hamburguer - Inativo'
  end
end