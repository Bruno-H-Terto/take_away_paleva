require 'rails_helper'

describe 'Proprietário filtra listagem de items por tag' do
  context 'a partir da tela de listagem padrão' do
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
      item_1 = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      item_2 = store.items.create!(name: 'Hamburguer', description: 'Artesanal', calories: 100, type: 'Dish')
      item_3 = store.items.create!(name: 'Coca-Cola', description: 'Zero açucar', calories: 30, type: 'Beverage')
      characteristic = store.characteristics.create!(quality_name: 'Salgado')
      other_characteristic = store.characteristics.create!(quality_name: 'Gaseificado')
      item_1.tags.create!(characteristic: characteristic)
      item_2.tags.create!(characteristic: characteristic)
      item_3.tags.create!(characteristic: other_characteristic)

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      select 'Salgado', from: 'Filtro'
      click_on 'Filtrar'

      expect(page).to have_content 'Pizza'
      expect(page).to have_content 'Hamburguer'
      expect(page).not_to have_content 'Coca-Cola'
    end

    it 'e não encontra resultados' do
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
      item_1 = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
      item_2 = store.items.create!(name: 'Hamburguer', description: 'Artesanal', calories: 100, type: 'Dish')
      characteristic = store.characteristics.create!(quality_name: 'Salgado')
      other_characteristic = store.characteristics.create!(quality_name: 'Gaseificado')
      item_1.tags.create!(characteristic: characteristic)
      item_2.tags.create!(characteristic: characteristic)

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      select 'Gaseificado', from: 'Filtro'
      click_on 'Filtrar'

      expect(page).to have_content 'Sem resultados para Gaseificado'
    end
  end
end