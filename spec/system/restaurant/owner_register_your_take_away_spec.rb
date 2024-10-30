require 'rails_helper'

describe 'Proprietário cadastra seu estabelecimento' do
  context 'autenticado' do
    it 'e direcionado após seu cadastro' do
      visit root_path
      click_on 'Sou Proprietário'
      click_on 'Nova conta'
      fill_in 'CPF', with: '759.942.990-57'
      fill_in 'Nome', with: 'Dom'
      fill_in 'Sobrenome', with: 'Corleone'
      fill_in 'E-mail', with: 'bigboss@email.com'
      fill_in 'Senha', with: 'treina_dev13'
      fill_in 'Confirme sua senha', with: 'treina_dev13'
      click_on 'Criar conta'
  
      expect(page).to have_content 'Conclua seu cadastro.'
      expect(page).to have_content 'Registre seu estabelecimento'
      expect(current_path).to eq  new_take_away_store_path
    end
  end
end