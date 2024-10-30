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

    expect(page).not_to have_content 'My Store'
    expect(page).not_to have_content 'Adicionar horário de funcionamento'
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
    click_on 'My Store'
    click_on 'Adicionar horário de funcionamento'
    fill_in_hours_for_day('monday', '09:00', '17:00', 'open')
    fill_in_hours_for_day('tuesday', '09:00', '17:00', 'open')
    fill_in_hours_for_day('wednesday', '09:00', '17:00', 'open')
    fill_in_hours_for_day('thursday', '09:00', '17:00', 'open')
    fill_in_hours_for_day('friday', '09:00', '17:00', 'open')
    fill_in_hours_for_day('saturday', '09:00', '17:00', 'closed')
    fill_in_hours_for_day('sunday', '09:00', '17:00', 'closed')
    click_on 'Registrar horários'

    expect(page).to have_content 'Horário registrado com sucesso'
    expect(page).to have_content 'Segunda-feira de 09:00 às 17:00'
    expect(page).to have_content 'Terça-feira de 09:00 às 17:00'
    expect(page).to have_content 'Quarta-feira de 09:00 às 17:00'
    expect(page).to have_content 'Quinta-feira de 09:00 às 17:00'
    expect(page).to have_content 'Sexta-feira de 09:00 às 17:00'
    expect(page).to have_content 'Sábado sem funcionamento'
    expect(page).to have_content 'Domingo sem funcionamento'
  end
end