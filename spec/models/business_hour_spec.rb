require 'rails_helper'

RSpec.describe BusinessHour, type: :model do
  context '#valid?' do

  it { should belong_to(:take_away_store) }

  it 'todos os campos válidos' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    take_away_store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
        email: 'potter@email.com')
    business_hour = BusinessHour.new(day_of_week: :monday, status: :open, open_time: '07:00',
                                     close_time: '12:00', take_away_store: take_away_store)

    expect(business_hour).to be_valid
  end

  it 'dia da semana só pode ter um expediente' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    take_away_store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
        email: 'potter@email.com')
    first_business_hour = BusinessHour.create!(day_of_week: :monday, status: :open, open_time: '07:00',
                                     close_time: '12:00', take_away_store: take_away_store)

    second_business_hour = BusinessHour.new(day_of_week: :monday, status: :open, open_time: '18:00',
                                     close_time: '21:00', take_away_store: take_away_store)        

    expect(second_business_hour).not_to be_valid
  end  
  
  it 'hora de abertura deve ter formato válido' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    take_away_store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
        email: 'potter@email.com')
    business_hour = BusinessHour.new(day_of_week: :monday, status: :open, open_time: 'ABC',
                                    close_time: '12:00', take_away_store: take_away_store)

    expect(business_hour).not_to be_valid
  end

  it 'hora de encerramento deve ter formato válido' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    take_away_store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
        email: 'potter@email.com')
    business_hour = BusinessHour.new(day_of_week: :monday, status: :open, open_time: '07:00',
                                    close_time: 'AB:AD', take_away_store: take_away_store)

    expect(business_hour).not_to be_valid
  end

  it 'hora de encerramento deve ser posterior a de abertura' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    take_away_store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
        email: 'potter@email.com')
      business_hour = BusinessHour.new(day_of_week: :monday, status: :closed, open_time: '11:00',
                                      close_time: '10:00', take_away_store: take_away_store)

      expect(business_hour).not_to be_valid
  end

  context '.open' do
    it 'hora de abertura é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      take_away_store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
          email: 'potter@email.com')
      business_hour = BusinessHour.new(day_of_week: :monday, status: :open, open_time: '',
                                      close_time: '12:00', take_away_store: take_away_store)

      expect(business_hour).not_to be_valid
    end

    it 'hora de encerramento é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      take_away_store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
          email: 'potter@email.com')
      business_hour = BusinessHour.new(day_of_week: :monday, status: :open, open_time: '07:00',
                                      close_time: '', take_away_store: take_away_store)

      expect(business_hour).not_to be_valid
    end
  end

  context '.closed' do
    it 'horários são opcionais' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
          email: 'quadribol@email.com', password: 'treina_dev13')
      take_away_store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
          register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
          number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
          email: 'potter@email.com')
      business_hour = BusinessHour.new(day_of_week: :monday, status: :closed, open_time: '',
                                       close_time: '', take_away_store: take_away_store)

      expect(business_hour).to be_valid
    end
  end
end
end
