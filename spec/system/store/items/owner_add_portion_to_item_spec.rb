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
        expect(page).to have_content 'Adicionar porção para Hamburguer'
        expect(page).to have_field 'Opção'
        expect(page).to have_css 'input[placeholder="Ex.: Pequena, Média..."]'
        expect(page).to have_field 'Descrição'
        expect(page).to have_css 'input[placeholder="Até 15 caracteres"]'
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
      fill_in 'Descrição', with: '2 pessoas'
      fill_in 'Preço', with: '3500'
      click_on 'Criar Porção'

      expect(page).to have_content 'Porção adicionada com sucesso!'
      within '#item_portions' do
        expect(page).to have_content 'Média - R$ 35,00'
      end
    end
  end
end