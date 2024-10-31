require 'rails_helper'

describe 'Proprietário edita os dados de seu estabelecimento' do
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
    click_on 'My Store'

    expect(page).to have_content 'Grifinória - Hogwarts LTDA - 76.898.265/0001-10'
    expect(page).to have_content 'Beco diagonal, nº 13'
    expect(page).to have_content 'Hogsmeade, SP'
    expect(page).to have_content 'Bolsão'
    expect(page).to have_content 'potter@email.com | (11) 98800-0000'
    expect(page).to have_link 'Editar dados'
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
    visit root_path
    click_on 'My Store'
    click_on 'Editar dados'
    fill_in 'Complemento', with: 'Loja 1'
    fill_in 'Número', with: '42'
    fill_in 'Telefone', with: '(11) 2100-0000'
    fill_in 'E-mail', with: 'hogsmeade@email.com'
    click_on 'Atualizar Estabelecimento'

    expect(page).to have_content 'Grifinória atualizado(a) com sucesso'
    expect(page).to have_content 'Grifinória - Hogwarts LTDA - 76.898.265/0001-10'
    expect(page).to have_content 'Beco diagonal, nº 42'
    expect(page).to have_content 'Hogsmeade, SP'
    expect(page).to have_content 'Bolsão'
    expect(page).to have_content 'hogsmeade@email.com | (11) 2100-0000'
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
    click_on 'Editar dados'
    fill_in 'Número', with: ''
    fill_in 'Telefone', with: ''
    click_on 'Atualizar Estabelecimento'

    expect(page).to have_content 'Não foi possível atualizar seu estabelecimento, reveja os campos abaixo:'
    expect(page).to have_content '2 erros localizados'
    expect(page).to have_content 'Telefone não pode ficar em branco'
    expect(page).to have_content 'Número não pode ficar em branco'
  end
end