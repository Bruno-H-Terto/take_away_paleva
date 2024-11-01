require 'rails_helper'

describe 'Proprietário deleta items' do
  context 'tipo Prato' do
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

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Pizza'
      click_on 'Excluir'

      expect(page).to have_content 'Prato excluído com sucesso!'
      expect(page).not_to have_content 'Pizza'
      expect(Dish.count).to eq 0
    end

    it 'excluí apenas o item selecionado' do
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
      store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      store.items.create!(name: 'Hamburguer', description: 'Artesanla', calories: 120, type: 'Dish')

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Pizza'
      click_on 'Excluir'

      expect(page).to have_content 'Prato excluído com sucesso!'
      expect(page).not_to have_content 'Pizza'
      expect(page).not_to have_content 'Hamburguer'
      expect(Dish.count).to eq 1
    end
  end

  context 'Bebida' do
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
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Vinho tinto'
      click_on 'Excluir'

      expect(page).to have_content 'Bebida excluída com sucesso!'
      expect(page).not_to have_content 'Vinho tinto'
      expect(Beverage.count).to eq 0
    end

    it 'excluí apenas o item selecionado' do
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
      store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 120, type: 'Beverage')
      store.items.create!(name: 'Coca-Cola', description: '2l', calories: 120, type: 'Beverage')

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Vinho tinto'
      click_on 'Excluir'

      expect(page).to have_content 'Bebida excluída com sucesso!'
      expect(page).not_to have_content 'Vinho tinto'
      expect(page).not_to have_content 'Coca-Cola'
      expect(Beverage.count).to eq 1
    end
  end
end