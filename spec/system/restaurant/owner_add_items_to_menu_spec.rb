require 'rails_helper'

describe 'Proprietário adiciona novos itens ao menu' do
  context 'Pratos' do
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
      click_on 'Meu cardápio'
      click_on 'Novo Prato'
      fill_in 'Nome', with: 'Hamburguer'
      attach_file 'Imagens', [Rails.root.join('spec/support/files/hamburguer.jpg'), Rails.root.join('spec/support/files/hamburguer-2.jpeg')]
      fill_in 'Descrição', with: 'Hamburguer artesanal feito na chapa'
      fill_in 'Calorias', with: 60
      click_on 'Cadastrar Prato'

      format_date = I18n.l(Date.today, format: "%d/%m/%Y")
      expect(page).to have_content 'Prato adicionado com sucesso!'
      expect(page).to have_content 'Hamburguer'
      expect(page).to have_content "Adicionado em #{format_date}"
      expect(page).to have_content 'Hamburguer artesanal feito na chapa'
      expect(page).to have_content '60 Calorias'
      expect(page).to have_css('img[src*="hamburguer.jpg"]')
      expect(page).to have_css('img[src*="hamburguer-2.jpeg"]')
    end

    it 'falha ao preencher campos obrigatórios' do
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
      click_on 'Meu cardápio'
      click_on 'Novo Prato'
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Calorias', with: ''
      click_on 'Cadastrar Prato'

      expect(page).to have_content 'Não foi possível cadastrar seu prato'
      expect(page).to have_content '2 erros localizados'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Descrição não pode ficar em branco'
    end
  end

  context 'Bebidas' do
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
      click_on 'Meu cardápio'
      click_on 'Nova Bebida'
      fill_in 'Nome', with: 'Vinho tinto'
      attach_file 'Imagens', [Rails.root.join('spec/support/files/vinho-tinto.jpeg'), Rails.root.join('spec/support/files/vinho-tinto-2.jpeg')]
      fill_in 'Descrição', with: 'Safra de 1998'
      fill_in 'Calorias', with: 70
      click_on 'Cadastrar Bebida'

      format_date = I18n.l(Date.today, format: "%d/%m/%Y")
      expect(page).to have_content 'Bebida adicionada com sucesso!'
      expect(page).to have_content 'Bebida'
      expect(page).to have_content "Adicionado em #{format_date}"
      expect(page).to have_content 'Safra de 1998'
      expect(page).to have_content '70 Calorias'
      expect(page).to have_css('img[src*="vinho-tinto.jpeg"]')
      expect(page).to have_css('img[src*="vinho-tinto-2.jpeg"]')
    end

    it 'falha ao preencher campos obrigatórios' do
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
      click_on 'Meu cardápio'
      click_on 'Nova Bebida'
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: ''
      fill_in 'Calorias', with: ''
      click_on 'Cadastrar Bebida'

      expect(page).to have_content 'Não foi possível cadastrar sua bebida'
      expect(page).to have_content '2 erros localizados'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Descrição não pode ficar em branco'
    end
  end
end