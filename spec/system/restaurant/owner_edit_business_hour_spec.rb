require 'rails_helper'

describe 'Proprietário atualiza se horário de funcionamento' do
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
    visit root_path
    click_on 'My Store'
    click_on 'Segunda-feira de 09:00 às 17:00'
    select 'Aberto', from: 'Funcionamento'
    fill_in 'Hora de abertura', with: '12:35'
    fill_in 'Encerramento', with: '18:00'
    click_on 'Atualizar Horário'

    expect(page).to have_content 'Horário atualizado com sucesso'
    expect(page).to have_content 'Segunda-feira de 12:35 às 18:00'
    expect(page).to have_content 'Terça-feira de 09:00 às 17:00'
    expect(page).to have_content 'Quarta-feira de 09:00 às 17:00'
    expect(page).to have_content 'Quinta-feira de 09:00 às 17:00'
    expect(page).to have_content 'Sexta-feira de 09:00 às 17:00'
    expect(page).to have_content 'Sábado de 09:00 às 17:00'
    expect(page).to have_content 'Domingo de 09:00 às 17:00'
  end

  it 'e falha ao não incluir informações obrigatórias' do
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
    click_on 'My Store'
    click_on 'Segunda-feira de 09:00 às 17:00'
    select 'Aberto', from: 'Funcionamento'
    fill_in 'Hora de abertura', with: ''
    fill_in 'Encerramento', with: '18:00'
    click_on 'Atualizar Horário'

    expect(page).to have_content 'Não foi possível atualizar seu horário, revise os campos abaixo:'
    expect(page).to have_content 'Segunda-feira - horários inválidos'
  end
end