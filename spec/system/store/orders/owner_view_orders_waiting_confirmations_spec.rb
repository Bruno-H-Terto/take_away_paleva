require 'rails_helper'

describe 'Proprietário acessa pedidos aguardando confirmação' do
  it 'a partir de página inicial' do
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
    portion = dish.portions.create!(option_name: 'Média', value: 7000)
    menu = store.menus.create!(name: 'Fast Food')
    menu.item_menus.create!(item: dish)
    order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860-71')
    order.order_items.create!(menu: menu, item: dish, portion: portion, quantity: 1, observation: 'Completo' )

    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus pedidos'

    within '#orders_waiting_confirmation' do
      expect(page).to have_content "Pedido - #{order.code}"
      expect(page).to have_content 'Cliente: Jhon'
    end
  end

  it 'e acessa detalhes de um pedido' do
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
    portion = dish.portions.create!(option_name: 'Média', value: 7000)
    menu = store.menus.create!(name: 'Fast Food')
    menu.item_menus.create!(item: dish)
    order = store.orders.create!(name: 'Jhon', phone_number: '', email: 'jhon@email.com', register_number: '362.164.860-71')
    order.order_items.create!(menu: menu, item: dish, portion: portion, quantity: 1, observation: 'Completo' )
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus pedidos'
    click_on "Pedido - #{order.code}"

    formated_time = Time.now.strftime("%d/%m/%Y %H:%M")
    expect(page).to have_content "Solicitado em #{formated_time}"
    expect(page).to have_content 'Cliente: Jhon'
    expect(page).to have_content 'Contato: Sem telefone - jhon@email.com'
    expect(page).to have_content 'Itens do pedido'
    expect(page).to have_content 'Menu: Fast Food'
    expect(page).to have_content 'Item: Pizza'
    expect(page).to have_content 'Quantidade: 1'
    expect(page).to have_content 'Porção: Média - R$ 70,00'
    expect(page).to have_content 'Observação: Completo'
    expect(page).to have_content 'Aguardando confirmação da cozinha'
  end
end