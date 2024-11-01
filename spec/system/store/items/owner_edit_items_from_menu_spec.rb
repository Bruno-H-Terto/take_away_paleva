require 'rails_helper'

describe 'Proprietário edita items do Menu' do
  it 'deve estar autenticado' do
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
    beverage = store.items.create!(name: 'Coca-Cola', description: 'Zero açucar', calories: 30, type: 'Beverage')

    visit root_path
    
    expect(page).not_to have_content 'Pizza'
    expect(page).not_to have_content 'Coca-Cola'
  end

  context 'do tipo Prato' do
    it 'e visualiza tela de detalhes' do
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

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meu cardápio'
      click_on 'Pizza'
      
      expect(page).to have_content 'Pizza'
      expect(page).to have_content 'Ativo'
      expect(page).to have_button 'Alterar status'
      expect(page).to have_content 'Quatro queijos'
      expect(page).to have_content 'Editar'
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
      photo = fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'pizza-1.jpg'))
      dish = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish',
             photo: photo)

      login_as owner, scope: :owner
      visit take_away_store_dish_path(store, dish)
      click_on 'Editar'
      fill_in 'Nome', with: 'Pizza quatro queijos'
      attach_file 'Foto', Rails.root.join('spec/support/files/pizza-2.jpeg')
      fill_in 'Descrição', with: 'Tamanho família'
      click_on 'Salvar e continuar'

      expect(page).to have_content 'Prato atualizado com sucesso'
      expect(page).to have_content 'Pizza quatro queijos'
      expect(page).to have_content 'Tamanho família'
      expect(page).to have_content '120 Calorias'
      expect(page).not_to have_css('img[src*="pizza-1.jpg"]')
      expect(page).to have_css('img[src*="pizza-2.jpeg"]')
    end

    it 'e altera seu status' do
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

      login_as owner, scope: :owner
      visit take_away_store_dish_path(store, dish)
      click_on 'Alterar status'

      expect(page).to have_content 'Pizza'
      expect(page).to have_content 'Inativo'
      expect(Item.find(dish.id).active?).to eq false
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

      login_as owner, scope: :owner
      visit take_away_store_dish_path(store, dish)
      click_on 'Editar'
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: 'Tamanho família'
      click_on 'Salvar e continuar'

      expect(page).to have_content 'Não foi possível atualizar seu prato'
      expect(page).to have_content '1 erro localizado'
      expect(page).to have_content 'Nome não pode ficar em branco'
    end

    it 'e visualiza apenas informações do próprio estabelecimento' do
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
      visit take_away_store_dish_path(store, owner)
      
      expect(page).to have_content 'Acesso não autorizado'
      expect(page).to have_content 'Pastelaria Top'
      expect(page).not_to have_content 'Grifinória'
      expect(current_path).to eq take_away_store_path(other_store)
    end
  end

  context 'do tipo Bebida' do
    it 'e visualiza tela de detalhes' do
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
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage').inactive!

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meu cardápio'
      click_on 'Vinho'
      
      expect(page).to have_content 'Vinho tinto'
      expect(page).to have_content 'Inativo'
      expect(page).to have_button 'Alterar status'
      expect(page).to have_content '750ml'
      expect(page).to have_content 'Editar'
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
      photo = fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'vinho-tinto.jpeg'))
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage',
              photo: photo)

      login_as owner, scope: :owner
      visit take_away_store_beverage_path(store, drink)
      click_on 'Editar'
      fill_in 'Nome', with: 'Vinho tinto Miliasso'
      attach_file 'Foto', Rails.root.join('spec/support/files/vinho-tinto-2.jpeg')
      fill_in 'Descrição', with: 'Safra 1992'
      click_on 'Salvar e continuar'

      expect(page).to have_content 'Bebida atualizada com sucesso'
      expect(page).to have_content 'Vinho tinto Miliasso'
      expect(page).to have_content 'Safra 1992'
      expect(page).to have_content '120 Calorias'
      expect(page).not_to have_css('img[src*="vinho-tinto.jpg"]')
      expect(page).to have_css('img[src*="vinho-tinto-2.jpeg"]')
    end

    it 'e altera seu status' do
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
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')
      drink.inactive!

      login_as owner, scope: :owner
      visit take_away_store_beverage_path(store, drink)
      click_on 'Alterar status'

      expect(page).to have_content 'Vinho tinto'
      expect(page).to have_content 'Ativo'
      expect(Item.find(drink.id).active?).to eq true
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
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')

      login_as owner, scope: :owner
      visit take_away_store_beverage_path(store, drink)
      click_on 'Editar'
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: 'Safra 1992'
      click_on 'Salvar e continuar'

      expect(page).to have_content 'Não foi possível atualizar sua bebida'
      expect(page).to have_content '1 erro localizado'
      expect(page).to have_content 'Nome não pode ficar em branco'
    end

    it 'e visualiza apenas informações do próprio estabelecimento' do
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
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')
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
      visit take_away_store_dish_path(store, owner)
      
      expect(page).to have_content 'Acesso não autorizado'
      expect(page).to have_content 'Pastelaria Top'
      expect(page).not_to have_content 'Grifinória'
      expect(current_path).to eq take_away_store_path(other_store)
    end
  end
end