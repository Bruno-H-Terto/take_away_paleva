require 'rails_helper'

describe 'Proprietário adiciona novos itens ao menu' do
  context 'Pratos' do
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
  
      visit take_away_store_dish_path(store, owner)
      
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
      expect(page).not_to have_content 'Grifinória'
    end

    it 'a partir da página inicial' do
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

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Novo Prato'
      fill_in 'Nome', with: 'Hamburguer'
      attach_file 'Foto', Rails.root.join('spec/support/files/hamburguer.jpg')
      fill_in 'Descrição', with: 'Hamburguer artesanal feito na chapa'
      fill_in 'Calorias', with: 60
      click_on 'Salvar e continuar'

      expect(page).to have_content 'Prato adicionado com sucesso!'
      expect(page).to have_content 'Hamburguer'
      expect(page).to have_content 'Hamburguer artesanal feito na chapa'
      expect(page).to have_content '60 Calorias'
      expect(page).to have_css('img[src*="hamburguer.jpg"]')
    end

    it 'falha ao não preencher campos obrigatórios' do
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

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Novo Prato'
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Calorias', with: ''
      click_on 'Salvar e continuar'

      expect(page).to have_content 'Não foi possível cadastrar seu prato'
      expect(page).to have_content '2 erros localizados'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Descrição não pode ficar em branco'
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

  context 'Bebidas' do
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
  
      visit take_away_store_beverage_path(store, owner)
      
      expect(page).to have_content 'Para continuar, faça login ou registre-se.'
      expect(page).not_to have_content 'Grifinória'
    end

    it 'a partir da página inicial' do
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

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Nova Bebida'
      fill_in 'Nome', with: 'Vinho tinto'
      attach_file 'Foto', Rails.root.join('spec', 'support', 'files', 'vinho-tinto.jpeg')
      fill_in 'Descrição', with: 'Safra de 1998'
      fill_in 'Calorias', with: 70
      click_on 'Salvar e continuar'

      expect(page).to have_content 'Bebida adicionada com sucesso!'
      expect(page).to have_content 'Bebida'
      expect(page).to have_content 'Safra de 1998'
      expect(page).to have_content '70 Calorias'
      expect(page).to have_css('img[src*="vinho-tinto.jpeg"]')
    end

    it 'falha ao não preencher campos obrigatórios' do
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

      login_as owner, scope: :owner
      visit root_path
      click_on 'Meus produtos'
      click_on 'Nova Bebida'
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Calorias', with: ''
      click_on 'Salvar e continuar'

      expect(page).to have_content 'Não foi possível cadastrar sua bebida'
      expect(page).to have_content '2 erros localizados'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Descrição não pode ficar em branco'
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