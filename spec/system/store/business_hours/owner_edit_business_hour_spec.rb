require 'rails_helper'

describe 'Proprietário atualiza se Meus Horários' do
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
    click_on 'Meus Horários'
    click_on 'Segunda-feira'
    select 'Aberto', from: 'Funcionamento'
    fill_in 'Hora de abertura', with: '12:35'
    fill_in 'Encerramento', with: '18:00'
    click_on 'Atualizar Horário'

    expect(page).to have_content 'Horário atualizado com sucesso'
    within '#monday' do
      expect(page).to have_content 'Segunda-feira'
      expect(page).to have_content '12:35'
      expect(page).to have_content '18:00'
    end
    within '#tuesday' do
      expect(page).to have_content 'Terça-feira'
      expect(page).to have_content '09:00'
      expect(page).to have_content '17:00'
    end
    within '#wednesday' do
      expect(page).to have_content 'Quarta-feira'
      expect(page).to have_content '09:00'
      expect(page).to have_content '17:00'
    end
    within '#thursday' do
      expect(page).to have_content 'Quinta-feira'
      expect(page).to have_content '09:00'
      expect(page).to have_content '17:00'
    end
    within '#friday' do
      expect(page).to have_content 'Sexta-feira'
      expect(page).to have_content '09:00'
      expect(page).to have_content '17:00'
    end
    within '#saturday' do
      expect(page).to have_content 'Sábado'
      expect(page).to have_content '09:00'
      expect(page).to have_content '17:00'
    end
    within '#sunday' do
      expect(page).to have_content 'Domingo'
      expect(page).to have_content '09:00'
      expect(page).to have_content '17:00'
    end
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
    click_on 'Meus Horários'
    click_on 'Segunda-feira'
    select 'Aberto', from: 'Funcionamento'
    fill_in 'Hora de abertura', with: ''
    fill_in 'Encerramento', with: '18:00'
    click_on 'Atualizar Horário'

    expect(page).to have_content 'Não foi possível atualizar seu horário, revise os campos abaixo:'
    expect(page).to have_content 'Segunda-feira - horários inválidos'
  end

  it 'só é permitido a editar dados da própria loja' do
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
    monday = store.business_hours.first
    visit edit_take_away_store_business_hour_path(store, monday)

    expect(page).to have_content 'Acesso negado - Não é permito visualizar dados de outro Estabelecimento'
    expect(current_path).to eq take_away_store_path(other_store)
  end

  it 'só é permitido a visualizar dados da própria loja' do
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
    visit take_away_store_business_hours_path(store)

    expect(page).to have_content 'Acesso negado - Não é permito visualizar dados de outro Estabelecimento'
    expect(current_path).to eq take_away_store_path(other_store)
  end
end