require 'rails_helper'

RSpec.describe Owner, type: :model do
  context '#valid?' do
    it { should have_one(:take_away_store) }
    it { should have_one(:unique_field) }
    
    it 'todos os campos válidos' do
      owner = Owner.new(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')

      expect(owner).to be_valid
    end

    it 'nome é obrigatório' do
      owner = Owner.new(name: '', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')

      expect(owner).not_to be_valid
    end

    it 'sobrenome é obrigatório' do
      owner = Owner.new(name: 'Finn', surname: '', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')

      expect(owner).not_to be_valid
    end

    it 'CPF é obrigatório' do
      owner = Owner.new(name: 'Finn', surname: 'Jake', register_number: '',
             email: 'adventure@time.com', password: 'treina_dev13')

      expect(owner).not_to be_valid
    end

    it 'CPF deve ser válido' do
      first_owner = Owner.new(name: 'Finn', surname: 'Jake', register_number: '402.793.150-00',
             email: 'adventure@time.com', password: 'treina_dev13')
      second_owner = Owner.new(name: 'Finn', surname: 'Jake', register_number: '111.111.111-11',
             email: 'adventure@time.com', password: 'treina_dev13')

      expect(first_owner).not_to be_valid
      expect(second_owner).not_to be_valid
    end

    it 'CPF não pode conter letras' do
      owner = Owner.new(name: 'Finn', surname: 'Jake', register_number: '40A.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')

      expect(owner).not_to be_valid
    end

    it 'CPF não pode conter simbolos' do
      owner = Owner.new(name: 'Finn', surname: 'Jake', register_number: '402.79$.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')

      expect(owner).not_to be_valid
    end

    it 'CPF deve ser único entre Proprietários' do
      first_owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')
      second_owner = Owner.new(name: 'Jhon', surname: 'Doe', register_number: '402.793.150-58',
             email: 'jhon@doe.com', password: 'treina_dev13')

      expect(second_owner).not_to be_valid
    end

    it 'email deve ser único entre Proprietários' do
      first_owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')
      second_owner = Owner.new(name: 'Jhon', surname: 'Doe', register_number: '362.164.860-71',
             email: 'adventure@time.com', password: 'treina_dev13')

      expect(second_owner).not_to be_valid
    end

    it 'CPF deve ser único entre Proprietários e Funcionários' do
      first_owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')
      store = first_owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
             register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
             number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
             email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
             close_time: '17:00')
      end
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
             email: 'bob@email.com', password: 'treina_dev13')

      second_owner = Owner.new(name: 'Jhon', surname: 'Doe', register_number: '362.164.860-71',
             email: 'jhon@doe.com', password: 'treina_dev13')
   
      expect(second_owner.save).to be_falsey
      expect(Owner.count).to eq 1
    end

    it 'email deve ser único entre Proprietários e Funcionários' do
      first_owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')
      store = first_owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
             register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
             number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
             email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
             close_time: '17:00')
      end
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
             email: 'bob@email.com', password: 'treina_dev13')

      second_owner = Owner.new(name: 'Jhon', surname: 'Doe', register_number: '750.209.140-88',
             email: 'bob@email.com', password: 'treina_dev13')
   
      expect(second_owner.save).to be_falsey
      expect(Owner.count).to eq 1
    end

    it 'email deve ser único entre Proprietários e Estabelecimentos' do
      first_owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')
      store = first_owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
             register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
             number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
             email: 'potter@email.com')
      BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
             close_time: '17:00')
      end

      second_owner = Owner.new(name: 'Jhon', surname: 'Doe', register_number: '750.209.140-88',
             email: 'potter@email.com', password: 'treina_dev13')
   
      expect(second_owner.save).to be_falsey
      expect(Owner.count).to eq 1
    end
  end
end
