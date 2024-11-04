require 'rails_helper'

describe 'Proprietário adiciona porções a um item' do
  context 'Pratos' do
    it 'deve estar autenticado' do
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
  
      visit take_away_store_dish_path(store, owner)
      
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
      expect(page).not_to have_content 'Pastel Dev'
    end

    it 'a partir da página inicial' do
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
      dish = store.items.create!(name: 'Hamburguer', description: 'Artesanal', calories: 100, type: 'Dish')

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Hamburguer'

      within '#item_portions' do
        expect(page).to have_content 'Adicionar porção'
        expect(page).to have_field 'Opção'
        expect(page).to have_css 'input[placeholder="Ex.: Pequena, Média..."]'
        expect(page).to have_field 'Preço'
        expect(page).to have_content 'Sem porções registradas'
      end
    end

    it 'com sucesso' do
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
      dish = store.items.create!(name: 'Hamburguer', description: 'Artesanal', calories: 100, type: 'Dish')

      login_as owner, scope: :owner
      visit take_away_store_dish_path(store, dish)
      fill_in 'Opção', with: 'Média'
      fill_in 'Preço', with: '3500'
      click_on 'Criar Porção'

      expect(page).to have_content 'Porção adicionada com sucesso!'
      within '#item_portions' do
        expect(page).to have_content 'Média - R$ 35,00'
      end
    end

    it 'multiplas porções' do
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
      dish = store.items.create!(name: 'Hamburguer', description: 'Artesanal', calories: 100, type: 'Dish')
      dish.portions.create!(option_name: 'Pequena', value: 1800)
      dish.portions.create!(option_name: 'Grande', value: 4400)

      login_as owner, scope: :owner
      visit take_away_store_dish_path(store, dish)
      fill_in 'Opção', with: 'Média'
      fill_in 'Preço', with: '3500'
      click_on 'Criar Porção'

      expect(page).to have_content 'Pequena - R$ 18,00'
      expect(page).to have_content 'Média - R$ 35,00'
      expect(page).to have_content 'Grande - R$ 44,00'
    end

    it 'falha ao não inserir dados obrigatórios' do
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
      dish = store.items.create!(name: 'Hamburguer', description: 'Artesanal', calories: 100, type: 'Dish')

      login_as owner, scope: :owner
      visit take_away_store_dish_path(store, dish)
      fill_in 'Opção', with: ''
      fill_in 'Preço', with: ''
      click_on 'Criar Porção'

      expect(page).to have_content 'Não foi possível adicionar sua porção'
      expect(page).to have_content 'Opção não pode ficar em branco'
      expect(page).to have_content 'Preço não pode ficar em branco'
    end
  end

  context 'Bebidas' do
    it 'deve estar autenticado' do
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
  
      visit take_away_store_dish_path(store, owner)
      
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
      expect(page).not_to have_content 'Pastel Dev'
    end

    it 'a partir da página inicial' do
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
      beverage = store.items.create!(name: 'Suco', description: 'Artesanal', calories: 30, type: 'Beverage')

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Suco'

      within '#item_portions' do
        expect(page).to have_content 'Adicionar porção'
        expect(page).to have_field 'Opção'
        expect(page).to have_css 'input[placeholder="Ex.: Pequena, Média..."]'
        expect(page).to have_field 'Preço'
        expect(page).to have_content 'Sem porções registradas'
      end
    end

    it 'com sucesso' do
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
      beverage = store.items.create!(name: 'Suco', description: 'Artesanal', calories: 30, type: 'Beverage')

      login_as owner, scope: :owner
      visit take_away_store_beverage_path(store, beverage)
      fill_in 'Opção', with: 'Média'
      fill_in 'Preço', with: '1200'
      click_on 'Criar Porção'

      expect(page).to have_content 'Porção adicionada com sucesso!'
      within '#item_portions' do
        expect(page).to have_content 'Média - R$ 12,00'
      end
    end

    it 'e falha por ultrapassar 15 caracteres' do
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
      beverage = store.items.create!(name: 'Suco', description: 'Artesanal', calories: 30, type: 'Beverage')

      login_as owner, scope: :owner
      visit take_away_store_beverage_path(store, beverage)
      fill_in 'Opção', with: 'Especial da noite'
      fill_in 'Preço', with: '1200'
      click_on 'Criar Porção'

      expect(page).to have_content 'Não foi possível adicionar sua porção'
      expect(page).to have_content '1 erro localizado'
      expect(page).to have_content 'Opção é muito longo (máximo: 15 caracteres)'
    end

    it 'multiplas porções' do
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
      drink = store.items.create!(name: 'Suco', description: 'Artesanal', calories: 100, type: 'Beverage')
      drink.portions.create!(option_name: 'Pequena', value: 1800)
      drink.portions.create!(option_name: 'Grande', value: 4400)

      login_as owner, scope: :owner
      visit take_away_store_beverage_path(store, drink)
      fill_in 'Opção', with: 'Média'
      fill_in 'Preço', with: '3500'
      click_on 'Criar Porção'

      expect(page).to have_content 'Pequena - R$ 18,00'
      expect(page).to have_content 'Média - R$ 35,00'
      expect(page).to have_content 'Grande - R$ 44,00'
    end

    it 'falha ao não inserir dados obrigatórios' do
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
      beverage = store.items.create!(name: 'Suco', description: 'Artesanal', calories: 30, type: 'Beverage')

      login_as owner, scope: :owner
      visit take_away_store_beverage_path(store, beverage)
      fill_in 'Opção', with: ''
      fill_in 'Preço', with: ''
      click_on 'Criar Porção'

      expect(page).to have_content 'Não foi possível adicionar sua porção'
      expect(page).to have_content 'Opção não pode ficar em branco'
      expect(page).to have_content 'Preço não pode ficar em branco'
    end
  end
end