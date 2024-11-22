require 'rails_helper'

describe 'Funcionário registrado navega pela aplicação' do
  context 'store' do
    it 'deve estar autenticado' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
        close_time: '17:00')
      end
      store.menus.create!(name: 'Café da manhã')
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      visit root_path

      expect(page).not_to have_content 'Minha Loja'
    end

    it 'e tem acesso a tela de detalhes do estabelecimento' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
        close_time: '17:00')
      end
      store.menus.create!(name: 'Café da manhã')
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      click_on 'Dados da Loja'

      expect(page).to have_content 'Loja'
      expect(page).to have_content "Código #{store.code}"
      expect(page).to have_content "Responsável: #{owner.full_name}"
      expect(page).to have_content 'Pizza Dev - Hogwarts LTDA - 76.898.265/0001-10'
      expect(page).to have_content 'Beco diagonal, nº 13'
      expect(page).to have_content 'Hogsmeade, SP'
      expect(page).to have_content 'Bolsão'
      expect(page).to have_content 'potter@email.com | (11) 98800-0000'
      expect(page).not_to have_link 'Editar dados'
      expect(page).not_to have_link 'Segunda-feira'
      expect(page).not_to have_link 'Terça-feira'
      expect(page).not_to have_link 'Quarta-feira'
      expect(page).not_to have_link 'Quinta-feira'
      expect(page).not_to have_link 'Sexta-feira'
      expect(page).not_to have_link 'Sábado'
      expect(page).not_to have_link 'Domingo'
    end
  end

  context 'menus' do
    it 'deve estar autenticado' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
        close_time: '17:00')
      end
      store.menus.create!(name: 'Café da manhã')
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      visit root_path

      expect(page).not_to have_content 'Café da manhã'
    end

    it 'e tem acesso a tela de cardápios' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
          email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
        close_time: '17:00')
      end
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      dish.portions.create!(option_name: 'Média', value: 7000)
      store.menus.create!(name: 'Café da manhã')
      store.menus.create!(name: 'Açai')
      store.menus.create!(name: 'Comida da Roça')
      menu = store.menus.create!(name: 'Fast Food')
      menu.item_menus.create!(item: dish)
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path

      expect(page).to have_content 'Café da manhã'
      expect(page).to have_content 'Açai'
      expect(page).to have_content 'Comida da Roça'
      within "#menu_#{menu.id}" do
        expect(page).to have_content 'Fast Food'
        expect(page).to have_content 'Pizza'
        expect(page).not_to have_link 'Mais Detalhes'
      end
    end
  end

  context 'orders' do
    it 'e adiciona itens ao carrinho' do
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
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      within "#menu_#{menu.id}" do
        select 'Média - R$ 70,00', from: 'portion_id'
        fill_in 'Quantidade', with: '2'
        fill_in 'Observação', with: 'Sem azeitonas'
        click_on 'Adicionar ao Carrinho'
      end

      expect(page).to have_content 'Item adicionado ao carrinho'
      within '#cart' do
        expect(page).to have_content 'Você possui itens aguardando confirmação'
        expect(page).to have_content 'Ir para o Carrinho'
      end
    end

    it 'e falha ao deixar campos obrigatórios vazios' do
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
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      within "#menu_#{menu.id}" do
        click_on 'Adicionar ao Carrinho'
      end

      expect(page).to have_content 'Não foi possível adicionar seu item ao carrinho'
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
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      within "#menu_#{menu.id}" do
        select 'Média - R$ 70,00', from: 'portion_id'
        fill_in 'Quantidade', with: '2'
        fill_in 'Observação', with: 'Sem azeitonas'
        click_on 'Adicionar ao Carrinho'
      end
      within "#menu_#{other_menu.id}" do
        select 'Pequena - R$ 50,00', from: 'portion_id'
        fill_in 'Quantidade', with: '1'
        fill_in 'Observação', with: 'Cobertura de chocolate'
        click_on 'Adicionar ao Carrinho'
      end
      click_on 'Ir para o Carrinho'
  
      within '#order_item_1' do
        expect(page).to have_content 'Cardápio: Fast Food'
        expect(page).to have_content 'Produto: Pizza'
        expect(page).to have_content 'Quantidade: 2'
        expect(page).to have_content 'Porção: Média - R$ 70,00'
        expect(page).to have_content 'Observação: Sem azeitonas'
        expect(page).to have_content 'Editar'
        expect(page).to have_content 'Remover'
      end
      within '#order_item_2' do
        expect(page).to have_content 'Cardápio: Gelados'
        expect(page).to have_content 'Produto: Sorvete'
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
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      within "#menu_#{menu.id}" do
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

      expect(page).to have_content 'Cardápio: Café da manhã'
      expect(page).to have_content 'Produto: Pizza'
      expect(page).to have_content 'Quantidade: 1'
      expect(page).to have_content 'Porção: Média - R$ 70,00'
      expect(page).to have_content 'Observação: Completo'
    end

    it 'e falha ao não passar campos válidos na edição' do
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
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      within "#menu_#{menu.id}" do
        select 'Média - R$ 70,00', from: 'portion_id'
        fill_in 'Quantidade', with: '2'
        fill_in 'Observação', with: 'Sem azeitonas'
        click_on 'Adicionar ao Carrinho'
      end
      click_on 'Ir para o Carrinho'
      within '#order_item_1' do
        click_on 'Editar'
      end
      fill_in 'Observação', with: ''
      fill_in 'Quantidade', with: ''
      click_on 'Salvar'

      expect(page).to have_content 'Não foi possível atualizar seu item'
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
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      within "#menu_#{menu.id}" do
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
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      within "#menu_#{menu.id}" do
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
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      within "#menu_#{menu.id}" do
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
      within '#orders_waiting_confirmation' do
        expect(page).to have_content 'Aguardando confirmação da cozinha'
        expect(page).to have_content 'Cliente: Jhon'
        expect(page).to have_content 'Pedido - ABCD1234'
        expect(page).to have_content "Solicitado em #{formated_time}"
      end
    end

    it 'e falha ao não inserir campos obrigatórios' do
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
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      within "#menu_#{menu.id}" do
        select 'Média - R$ 70,00', from: 'portion_id'
        fill_in 'Quantidade', with: '2'
        fill_in 'Observação', with: 'Sem azeitonas'
        click_on 'Adicionar ao Carrinho'
      end
      click_on 'Ir para o Carrinho'
      click_on 'Confirmar Pedido'
      fill_in 'Nome do Cliente', with: ''
      fill_in 'Telefone de contato', with: ''
      fill_in 'E-mail', with: ''
      fill_in 'CPF', with: ''
      click_on 'Salvar e continuar'

      expect(page).to have_content 'Não foi possível concluir seu pedido'
      expect(page).to have_content '2 erros localizado'
      expect(page).to have_content 'Nome do Cliente não pode ficar em branco'
      expect(page).to have_content 'Telefone ou email deve ser passado'
    end

    it 'e acessa tela de detalhes do pedido' do
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
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
          email: 'bob@email.com', password: 'treina_dev13')

      login_as employee, scope: :employee
      visit root_path
      within "#menu_#{menu.id}" do
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
      click_on 'Pedido - ABCD1234'

      formated_time = Time.now.strftime("%d/%m/%Y %H:%M")
      expect(page).to have_content 'Cliente: Jhon'
      expect(page).to have_content 'Contato: (11) 999887744 - jhon@email.com'
      expect(page).to have_content 'Total do pedido: R$ 140,00'
      expect(page).to have_content 'Itens do pedido'
      expect(page).to have_content 'Cardápio: Fast Food'
      expect(page).to have_content 'Produto: Pizza'
      expect(page).to have_content 'Quantidade: 2'
      expect(page).to have_content 'Porção: Média'
      expect(page).to have_content 'Observação: Sem azeitonas'
      expect(page).to have_content 'Aguardando confirmação da cozinha'
    end
  end
end