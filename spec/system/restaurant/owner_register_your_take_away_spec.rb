require 'rails_helper'

describe 'Proprietário registra seu estabelecimento' do
  context 'autenticado' do
    it 'e é direcionado após seu cadastro' do
      visit root_path
      click_on 'Seja um parceiro'
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

    it 'e é direcionado após login caso não tenha concluído seu registro' do
      owner = Owner.create!(name: 'Vito', surname: 'Corleone', register_number: '402.793.150-58',
              email: 'vito@email.com', password: 'treina_dev13')

      visit root_path
      click_on 'Faça seu login'
      fill_in 'E-mail', with: 'vito@email.com'
      fill_in 'Senha', with: 'treina_dev13'
      click_on 'Log in'
  
      expect(page).to have_content 'Conclua seu cadastro.'
      expect(page).to have_content 'Registre seu estabelecimento'
      expect(current_path).to eq  new_take_away_store_path
    end

    it 'com sucesso' do
      owner = Owner.create!(name: 'Vito', surname: 'Corleone', register_number: '402.793.150-58',
              email: 'vito@email.com', password: 'treina_dev13')

      login_as owner, scope: :owner
      visit root_path
      fill_in 'Nome Fantasia', with: 'Big Boss Store'
      fill_in 'Razão Social', with: 'Corleone LTDA'
      fill_in 'CNPJ', with: '43.087.854/0001-60'
      fill_in 'Logradouro', with: 'Brooklyn Beach'
      fill_in 'Complemento', with: 'Loja 1'
      fill_in 'Número', with: '42'
      fill_in 'Bairro', with: 'Brooklyn'
      fill_in 'Cidade', with: 'Motta'
      fill_in 'Estado', with: 'MG'
      fill_in 'Telefone', with: '(11) 2100-0000'
      fill_in 'CEP', with: '11000-000'
      fill_in 'E-mail', with: 'bigboss@email.com'
      click_on 'Criar Estabelecimento'

      expect(page).to have_content 'Big Boss Store registrado(a) com sucesso'
      expect(page).to have_content 'Inclua seu horário de funcionamento'
    end

    it 'e falha ao não incluir campos obrigatórios' do
      owner = Owner.create!(name: 'Vito', surname: 'Corleone', register_number: '402.793.150-58',
              email: 'vito@email.com', password: 'treina_dev13')

      login_as owner, scope: :owner
      visit root_path
      fill_in 'Nome Fantasia', with: ''
      fill_in 'Razão Social', with: ''
      fill_in 'CNPJ', with: '43.087.854/0001-'
      fill_in 'Logradouro', with: ''
      fill_in 'Complemento', with: ''
      fill_in 'Número', with: '42'
      fill_in 'Bairro', with: 'Brooklyn'
      fill_in 'Cidade', with: 'Motta'
      fill_in 'Estado', with: 'MG'
      fill_in 'Telefone', with: '(11) 2100-000'
      fill_in 'E-mail', with: 'bigboss@email'
      click_on 'Criar Estabelecimento'

      expect(page).to have_content 'Não foi possível registrar seu estabelecimento, reveja os campos abaixo:'
      expect(page).to have_content '9 erros localizados'
      expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
      expect(page).to have_content 'Razão Social não pode ficar em branco'
      expect(page).to have_content 'CNPJ inválido'
      expect(page).to have_content 'Logradouro não pode ficar em branco'
      expect(page).to have_content 'CNPJ incorreto: digitado 12 números, esperado 14'
      expect(page).to have_content 'Telefone com formato inválido'
      expect(page).to have_content 'E-mail deve ser em um formato válido'
      expect(page).to have_content 'EP deve ser em um formato válido'
      expect(page).to have_content 'CEP não pode ficar em branco'
    end
  end
end