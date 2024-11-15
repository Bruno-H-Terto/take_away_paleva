require 'rails_helper'

describe 'Proprietário cria pré-cadastro de funcionários' do
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
          
    login_as owner, scope: :owner
    visit root_path
    click_on 'Meus funcionários'
    click_on 'Novo acesso'

    expect(page).to have_content 'Novo Funcionário'
    expect(page).to have_field 'CPF'
    expect(page).to have_field 'E-mail'
  end

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
          
    login_as owner, scope: :owner
    visit new_take_away_store_profile_path(store)
    fill_in 'CPF', with: '362.164.860-71'
    fill_in 'E-mail', with: 'bob@email.com'
    click_on 'Criar Funcionário'

    expect(page).to have_content 'Novo Funcionário registrado com sucesso!'
    expect(page).to have_content 'bob@email.com - Aguardando confirmação'
  end

  it 'e falha ao não inserir campos obrigatórios' do
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
    visit new_take_away_store_profile_path(store)
    fill_in 'CPF', with: ''
    fill_in 'E-mail', with: ''
    click_on 'Criar Funcionário'

    expect(page).to have_content 'Não foi possível registrar seu Funcionário'
    expect(page).to have_content '2 erros localizados'
    expect(page).to have_content 'CPF não pode ficar em branco'
    expect(page).to have_content 'E-mail não pode ficar em branco'
  end

  it 'e falha ao informar campos que já estão em uso' do
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
    store.profiles.create(register_number: '362.164.860-71', email: 'bob@email.com')
          
    login_as owner, scope: :owner
    visit new_take_away_store_profile_path(store)
    fill_in 'CPF', with: '362.164.860-71'
    fill_in 'E-mail', with: 'bob@email.com'
    click_on 'Criar Funcionário'

    expect(page).to have_content 'Não foi possível registrar seu Funcionário'
    expect(page).to have_content '2 erros localizados'
    expect(page).to have_content 'CPF já está em uso'
    expect(page).to have_content 'E-mail já está em uso'
  end

  it 'e falha ao informar campos invalidos' do
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
    visit new_take_away_store_profile_path(store)
    fill_in 'CPF', with: '362.164.860-'
    fill_in 'E-mail', with: 'bob@email'
    click_on 'Criar Funcionário'

    expect(page).to have_content 'Não foi possível registrar seu Funcionário'
    expect(page).to have_content '3 erros localizados'
    expect(page).to have_content 'CPF incorreto: digitado 9 números, esperado 11'
    expect(page).to have_content 'CPF inválido'
    expect(page).to have_content 'E-mail deve ser em um formato válido'
  end
end