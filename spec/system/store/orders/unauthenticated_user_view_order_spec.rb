require 'rails_helper'

describe 'Usuário não autenticado consulta pedidos' do
  it 'a partir de página inicial' do
    visit root_path

    expect(page).to have_content 'Consulte seu pedido aqui'
    expect(page).to have_field 'Código'
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
    portion = dish.portions.create!(option_name: 'Média', value: 7000)
    menu = store.menus.create!(name: 'Fast Food')
    menu.item_menus.create!(item: dish)
    order = store.orders.create!(name: 'Jhon', phone_number: '(11) 999887744', email: 'jhon@email.com', register_number: '362.164.860-71')
    order.preparing!
    order.done!
    order.finished!

    visit root_path
    fill_in 'Código', with: order.code
    click_on 'Buscar'

    expect(page).to have_content "Pedido #{order.code}"
    expect(page).to have_content 'Grifinória - Hogwarts LTDA - 76.898.265/0001-10'
    expect(page).to have_content 'Beco diagonal, nº 13'
    expect(page).to have_content 'Hogsmeade, SP'
    expect(page).to have_content 'Bolsão'
    expect(page).to have_content 'potter@email.com | (11) 98800-0000'
    formated_time = Time.now.strftime("%d/%m/%Y - %H:%M")
    expect(page).to have_content "Pedido realizado - #{formated_time}"
    expect(page).to have_content "Pedido aceito - #{formated_time}"
    expect(page).to have_content "Pedido concluído - #{formated_time}"
    expect(page).to have_content "Pedido entregue - #{formated_time}"
  end

  it 'e não localiza' do
    visit root_path
    fill_in 'Código', with: ''
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum pedido localizado!'
  end

  it 'Proprietário autenticado não tem acesso' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
          close_time: '17:00')

    login_as owner, scope: :owner
    visit search_order_path

    expect(page).to have_content 'Acesso não autorizado'
    expect(current_path).to eq root_path
    end
  end
end