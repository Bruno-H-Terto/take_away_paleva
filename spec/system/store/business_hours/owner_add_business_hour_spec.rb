require 'rails_helper'

describe 'Proprietário adiciona novos horários de funcionamento' do
  def fill_in_hours_for_day(day, open_time, close_time, open)
    within "##{day}" do
      if open == 'open'
        select 'Aberto', from: 'Funcionamento'
      end
      fill_in 'Hora de abertura', with: open_time
      fill_in 'Encerramento', with: close_time
    end
  end

  it 'deve estar autenticado' do
    visit root_path

    expect(page).not_to have_content 'Minha Loja'
    expect(page).not_to have_content 'Inclua seu horário de funcionamento'
  end
  
  it 'deve cadastrar seu horário de funcionamento logo após seu registro' do
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
    select 'MG', from: 'Estado'
    fill_in 'Telefone', with: '(11) 2100-0000'
    fill_in 'CEP', with: '11000-000'
    fill_in 'E-mail', with: 'bigboss@email.com'
    click_on 'Criar Estabelecimento'
    visit root_path

    expect(current_path).to eq new_take_away_store_business_hour_path(TakeAwayStore.last)
    expect(page).to have_content 'Para prosseguir, registre seu horário de funcionamento'
  end
  
  it 'é redirecionado para registrar seus horários caso não os tenha feito' do
    owner = Owner.create!(name: 'Vito', surname: 'Corleone', register_number: '402.793.150-58',
            email: 'vito@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')

    login_as owner, scope: :owner
    visit root_path

    expect(current_path).to eq new_take_away_store_business_hour_path(TakeAwayStore.last)
    expect(page).to have_content 'Para prosseguir, registre seu horário de funcionamento'
  end

  it 'com sucesso' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')

    login_as owner, scope: :owner
    visit root_path
    fill_in_hours_for_day('monday', '09:00', '17:00', 'open')
    fill_in_hours_for_day('tuesday', '09:00', '17:00', 'open')
    fill_in_hours_for_day('wednesday', '09:00', '17:00', 'open')
    fill_in_hours_for_day('thursday', '09:00', '17:00', 'open')
    fill_in_hours_for_day('friday', '09:00', '17:00', 'open')
    fill_in_hours_for_day('saturday', '09:00', '17:00', 'closed')
    fill_in_hours_for_day('sunday', '09:00', '17:00', 'closed')
    click_on 'Registrar horários'

    expect(page).to have_content 'Horário registrado com sucesso'
    within '#monday' do
      expect(page).to have_content 'Segunda-feira'
      expect(page).to have_content '09:00'
      expect(page).to have_content '17:00'
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
      expect(page).to have_content '--:--'
      expect(page).to have_content '--:--'
    end
    within '#sunday' do
      expect(page).to have_content 'Domingo'
      expect(page).to have_content '--:--'
      expect(page).to have_content '--:--'
    end
  end

  it 'falha ao selecionar Funcionamento, mas não passa o horário' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')

    login_as owner, scope: :owner
    visit root_path
    fill_in_hours_for_day('monday', '', '', 'open')
    fill_in_hours_for_day('tuesday', '09:00', '', 'open')
    fill_in_hours_for_day('wednesday', '', '17:00', 'open')
    click_on 'Registrar horários'

    expect(BusinessHour.count).to eq 0
    expect(page).to have_content 'Não foi possível incluir seus horários, revise os campos abaixo:'
    expect(page).to have_content 'Segunda-feira - horários inválidos'
    expect(page).to have_content 'Terça-feira - horários inválidos'
    expect(page).to have_content 'Quarta-feira - horários inválidos'
  end

  it 'todos vazios' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Registrar horários'

    expect(BusinessHour.count).to eq 0
    expect(page).to have_content 'Selecione ao menos um dia de funcionamento'
  end
end