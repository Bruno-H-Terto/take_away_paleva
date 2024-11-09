require 'rails_helper'

describe 'Proprietário registra um pedido' do
  it 'e adiciona itens no carrinho' do
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
    dish.portions.create!(option_name: 'Média', value: 7000)
    other_dish = store.items.create!(name: 'Sorvete', description: 'Quatro queijos', calories: 120, type: 'Dish')
    other_dish.portions.create!(option_name: 'Pequena', value: 5000)
    menu = store.menus.create!(name: 'Café da manhã')
    menu.item_menus.create!(item: dish)
    other_menu = store.menus.create!(name: 'Gelados')
    other_menu.item_menus.create!(item: other_dish)

    login_as owner, scope: :owner
    visit root_path
    within "##{dish.name}_menu_#{menu.id}" do
      click_on 'Adicionar ao Carrinho'
    end
    within "##{other_dish.name}_menu_#{other_menu.id}" do
      click_on 'Adicionar ao Carrinho'
    end

    expect(page).to have_content 'Item adicionado ao carrinho'
    within '#order' do
      expect(page).to have_button 'Confirmar Pedido'
    end
    within "#order_item_#{dish.id}" do
      expect(page).to have_content 'Pizza'
      expect(page).to have_field 'Observação'
      expect(page).to have_field 'Quantidade'
    end
    within "#order_item_#{other_dish.id}" do
      expect(page).to have_content 'Sorvete'
      expect(page).to have_field 'Observação'
      expect(page).to have_field 'Quantidade'
    end
  end

  it 'e insere dados do cliente ao pedido' do
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
    dish.portions.create!(option_name: 'Média', value: 7000)
    menu = store.menus.create!(name: 'Café da manhã')
    menu.item_menus.create!(item: dish)

    login_as owner, scope: :owner
    visit root_path
    within "##{dish.name}_menu_#{menu.id}" do
      click_on 'Adicionar ao Carrinho'
    end
    select 'Média', from: 'Opções'
    fill_in 'Quantidade', with: '1'
    fill_in 'Observação', with: 'Sem azeitona'
    click_on 'Confirmar Pedido'

    expect(page).to have_content 'Finalize seu Pedido'
    expect(page).to have_field 'Nome do Cliente'
    expect(page).to have_field 'Telefone'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'CPF'
  end
end