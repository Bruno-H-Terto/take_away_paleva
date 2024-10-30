require 'rails_helper'

describe 'Proprietário realiza seu cadastro' do
  it 'com sucesso' do
    visit root_path
    click_on 'Seja um parceiro'
    fill_in 'CPF', with: '759.942.990-57'
    fill_in 'Nome', with: 'Dom'
    fill_in 'Sobrenome', with: 'Corleone'
    fill_in 'E-mail', with: 'bigboss@email.com'
    fill_in 'Senha', with: 'treina_dev13'
    fill_in 'Confirme sua senha', with: 'treina_dev13'
    click_on 'Criar conta'

    expect(page).to have_css 'nav', text: 'Dom Corleone'
    expect(page).to have_css 'nav', text: 'bigboss@email.com'
  end

  it 'realiza logout após registro' do
    visit root_path
    click_on 'Seja um parceiro'
    fill_in 'CPF', with: '759.942.990-57'
    fill_in 'Nome', with: 'Dom'
    fill_in 'Sobrenome', with: 'Corleone'
    fill_in 'E-mail', with: 'bigboss@email.com'
    fill_in 'Senha', with: 'treina_dev13'
    fill_in 'Confirme sua senha', with: 'treina_dev13'
    click_on 'Criar conta'
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso.'
  end

  it 'e falha ao não preencher informações obrigatórias' do
    visit root_path
    click_on 'Seja um parceiro'
    fill_in 'CPF', with: ''
    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    fill_in 'E-mail', with: 'bigboss@email.com'
    fill_in 'Senha', with: 'treina_dev13'
    fill_in 'Confirme sua senha', with: 'treina_dev13'
    click_on 'Criar conta'

    expect(page).to have_content 'Não foi possível salvar proprietário: 3 erros.'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
    expect(page).to have_content 'CPF não pode ficar em branco'
  end

  it 'CPF inválido' do
    visit root_path
    click_on 'Seja um parceiro'
    fill_in 'CPF', with: '111.111.111-11'
    fill_in 'Nome', with: 'Dom'
    fill_in 'Sobrenome', with: 'Corleone'
    fill_in 'E-mail', with: 'bigboss@email.com'
    fill_in 'Senha', with: 'treina_dev13'
    fill_in 'Confirme sua senha', with: 'treina_dev13'
    click_on 'Criar conta'

    expect(page).to have_content 'Não foi possível salvar proprietário: 1 erro'
    expect(page).to have_content 'CPF numeração inválida'
  end
end