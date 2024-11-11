require 'rails_helper'

describe 'Funcionário se registra' do
  it 'a partir da página incial' do
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
    store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')

    visit root_path
    click_on 'Seja um parceiro'
    click_on 'Sou Funcionário'

    expect(page).to have_content 'Crie sua conta'
    expect(page).to have_field 'CPF'
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Sobrenome'
    expect(page).to have_field 'E-mail'
    expect(page).to have_field 'Senha'
    expect(page).to have_field 'Confirme sua senha'
  end

  it 'com sucesso' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
    store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
      close_time: '17:00')
    end
    store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')

    visit root_path
    click_on 'Seja um parceiro'
    click_on 'Sou Funcionário'
    fill_in 'CPF', with: '362.164.860-71'
    fill_in 'E-mail', with: 'bob@email.com'
    fill_in 'Nome', with: 'Bob'
    fill_in 'Sobrenome', with: 'Doe'
    fill_in 'Senha', with: 'treina_dev13'
    fill_in 'Confirme sua senha', with: 'treina_dev13'
    click_on 'Criar Conta'

    expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
    expect(page).to have_content 'Pizza Dev - bob@email.com'
  end

  it 'e falha ao não informação dados obrigatórios' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
    store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
      close_time: '17:00')
    end
    store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')

    visit root_path
    click_on 'Seja um parceiro'
    click_on 'Sou Funcionário'
    fill_in 'CPF', with: ''
    fill_in 'E-mail', with: 'bob@email.com'
    fill_in 'Nome', with: ''
    fill_in 'Sobrenome', with: ''
    fill_in 'Senha', with: 'treina_dev13'
    fill_in 'Confirme sua senha', with: 'treina_dev13'
    click_on 'Criar Conta'

    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Sobrenome não pode ficar em branco'
  end

  it 'deve estar com pré-cadastro ativo' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
    store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
      close_time: '17:00')
    end

    visit root_path
    click_on 'Seja um parceiro'
    click_on 'Sou Funcionário'
    fill_in 'CPF', with: '362.164.860-71'
    fill_in 'E-mail', with: 'bob@email.com'
    fill_in 'Nome', with: 'Bob'
    fill_in 'Sobrenome', with: 'Doe'
    fill_in 'Senha', with: 'treina_dev13'
    fill_in 'Confirme sua senha', with: 'treina_dev13'
    click_on 'Criar Conta'

    expect(page).to have_content 'Perfil não associado a um Estabelecimento ativo'
    expect(page).to have_content 'Perfil é obrigatório(a)'
  end
end