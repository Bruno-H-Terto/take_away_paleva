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
      fill_in 'Descrição', with: 'Hamburguer artesanal feito na chapa'
      fill_in 'Calorias', with: 60
      click_on 'Cadastrar Prato'

      format_date = I18n.l(Date.today, format: "%d/%m/%Y")
      expect(page).to have_content 'Prato adicionado com sucesso!'
      expect(page).to have_content 'Hamburguer'
      expect(page).to have_content "Adicionado em #{format_date}"
      expect(page).to have_content 'Hamburguer artesanal feito na chapa'
      expect(page).to have_content '60 Calorias'
    end
  end
end