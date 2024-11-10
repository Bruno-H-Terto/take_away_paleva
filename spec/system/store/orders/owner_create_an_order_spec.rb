require 'rails_helper'

describe 'Proprietário registra um pedido' do
  context 'carrinho' do
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
      menu = store.menus.create!(name: 'Café da manhã')
      menu.item_menus.create!(item: dish)

      login_as owner, scope: :owner
      visit root_path
      within "##{dish.name}_menu_#{menu.id}" do
        select 'Média - R$ 70,00', from: 'portion_id'
        fill_in 'Quantidade', with: '2'
        fill_in 'Observação', with: 'Sem azeitonas'
        click_on 'Adicionar ao Carrinho'
      end

      expect(page).to have_content 'Item adicionado ao carrinho'
      within '#order' do
        expect(page).to have_content 'Você possui itens aguardando confirmação'
        expect(page).to have_content 'Ir para o Carrinho'
      end
    end

    it 'e visualiza itens no carrinho' do
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
      menu = store.menus.create!(name: 'Fast Food')
      menu.item_menus.create!(item: dish)
      other_dish = store.items.create!(name: 'Sorvete', description: 'Quatro queijos', calories: 120, type: 'Dish')
      other_dish.portions.create!(option_name: 'Pequena', value: 5000)
      other_menu = store.menus.create!(name: 'Gelados')
      other_menu.item_menus.create!(item: other_dish)

  
      login_as owner, scope: :owner
      visit root_path
      within "##{dish.name}_menu_#{menu.id}" do
        select 'Média - R$ 70,00', from: 'portion_id'
        fill_in 'Quantidade', with: '2'
        fill_in 'Observação', with: 'Sem azeitonas'
        click_on 'Adicionar ao Carrinho'
      end
      within "##{other_dish.name}_menu_#{other_menu.id}" do
        select 'Pequena - R$ 50,00', from: 'portion_id'
        fill_in 'Quantidade', with: '1'
        fill_in 'Observação', with: 'Cobertura de chocolate'
        click_on 'Adicionar ao Carrinho'
      end
      click_on 'Ir para o Carrinho'
  
      within '#order_item_1' do
        expect(page).to have_content 'Menu: Fast Food'
        expect(page).to have_content 'Item: Pizza'
        expect(page).to have_content 'Quantidade: 2'
        expect(page).to have_content 'Porção: Média - R$ 70,00'
        expect(page).to have_content 'Observação: Sem azeitonas'
        expect(page).to have_content 'Editar'
        expect(page).to have_content 'Remover'
      end
      within '#order_item_2' do
        expect(page).to have_content 'Menu: Gelados'
        expect(page).to have_content 'Item: Sorvete'
        expect(page).to have_content 'Quantidade: 1'
        expect(page).to have_content 'Porção: Pequena - R$ 50,00'
        expect(page).to have_content 'Observação: Cobertura de chocolate'
        expect(page).to have_content 'Editar'
        expect(page).to have_content 'Remover'
      end
      expect(page).to have_content 'Total do Pedido: R$ 190,00'
    end

    it 'e edita itens do carrinho' do
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
        select 'Média - R$ 70,00', from: 'portion_id'
        fill_in 'Quantidade', with: '2'
        fill_in 'Observação', with: 'Sem azeitonas'
        click_on 'Adicionar ao Carrinho'
      end
      click_on 'Ir para o Carrinho'
      within '#order_item_1' do
        click_on 'Editar'
      end
      fill_in 'Observação', with: 'Completo'
      fill_in 'Quantidade', with: '1'
      click_on 'Salvar'

      expect(page).to have_content 'Menu: Café da manhã'
      expect(page).to have_content 'Item: Pizza'
      expect(page).to have_content 'Quantidade: 1'
      expect(page).to have_content 'Porção: Média - R$ 70,00'
      expect(page).to have_content 'Observação: Completo'
    end

    it 'e remove itens do carrinho' do
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
        select 'Média - R$ 70,00', from: 'portion_id'
        fill_in 'Quantidade', with: '2'
        fill_in 'Observação', with: 'Sem azeitonas'
        click_on 'Adicionar ao Carrinho'
      end
      click_on 'Ir para o Carrinho'
      within '#order_item_1' do
        click_on 'Remover'
      end

      expect(page).to have_content 'Item removido do carrinho'
      expect(page).to have_content 'Carrinho vázio, volte a página inicial para cadastrar novos itens'
    end
  end

  it 'e acessa tela de registro do cliente' do
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
    menu = store.menus.create!(name: 'Fast Food')
    menu.item_menus.create!(item: dish)

    login_as owner, scope: :owner
    visit root_path
    within "##{dish.name}_menu_#{menu.id}" do
      select 'Média - R$ 70,00', from: 'portion_id'
      fill_in 'Quantidade', with: '2'
      fill_in 'Observação', with: 'Sem azeitonas'
      click_on 'Adicionar ao Carrinho'
    end
    click_on 'Ir para o Carrinho'
    click_on 'Confirmar Pedido'

    expect(page).to have_field 'Nome do Cliente'
    expect(page).to have_field 'Telefone de contato'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'CPF'
  end

  it 'e confirma o pedido com sucesso' do
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
    menu = store.menus.create!(name: 'Fast Food')
    menu.item_menus.create!(item: dish)
    allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('ABCD1234')

    login_as owner, scope: :owner
    visit root_path
    within "##{dish.name}_menu_#{menu.id}" do
      select 'Média - R$ 70,00', from: 'portion_id'
      fill_in 'Quantidade', with: '2'
      fill_in 'Observação', with: 'Sem azeitonas'
      click_on 'Adicionar ao Carrinho'
    end
    click_on 'Ir para o Carrinho'
    click_on 'Confirmar Pedido'
    fill_in 'Nome do Cliente', with: 'Jhon'
    fill_in 'Telefone de contato', with: '(11) 999887744'
    fill_in 'E-mail', with: 'jhon@email.com'
    fill_in 'CPF', with: '533.589.960-34'
    click_on 'Salvar e continuar'

    formated_time = Time.now.strftime("%d/%m/%Y %H:%M")
    expect(page).to have_content 'Pedido registrado com sucesso!'
    expect(page).to have_content 'Pedidos aguardando confirmação'
    expect(page).to have_content 'Cliente: Jhon'
    expect(page).to have_content 'Pedido - ABCD1234'
    expect(page).to have_content "Solicitado em #{formated_time}"
  end
end