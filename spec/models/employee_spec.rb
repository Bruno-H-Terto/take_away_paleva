require 'rails_helper'

RSpec.describe Employee, type: :model do
  context '#valid?' do
    it { should belong_to(:profile) }
    it { should have_one(:take_away_store).through(:profile) }

    it 'todos os campos válidos' do
      owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
            email: 'adventure@time.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')
      profile = store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')

      employee = Employee.new(name: 'Bob', surname: 'Construtor', register_number: '362.164.860-71',
            email: 'bob@email.com', password: 'treina_dev13')

      expect(employee).to be_valid
    end

    it 'nome é obrigatório' do
      owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
            email: 'adventure@time.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')
      profile = store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')

      employee = Employee.new(name: '', surname: 'Construtor', register_number: '362.164.860-71',
            email: 'bob@email.com', password: 'treina_dev13')

      expect(employee).not_to be_valid
    end

    it 'sobrenome é obrigatório' do
      owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
            email: 'adventure@time.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')
      profile = store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')

      employee = Employee.new(name: 'Bob', surname: '', register_number: '362.164.860-71',
            email: 'bob@email.com', password: 'treina_dev13')

      expect(employee).not_to be_valid
    end

    it 'CPF deve ser idêntico ao informado no pre-cadastro' do
      owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
            email: 'adventure@time.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')
      profile = store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')

      employee = Employee.new(name: 'Bob', surname: 'Construtor', register_number: '285.665.390-10',
            email: 'bob@email.com', password: 'treina_dev13')

      expect(employee).not_to be_valid
    end

    it 'E-mail deve ser idêntico ao informado no pré-cadastro' do
      owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
            email: 'adventure@time.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')
      profile = store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')

      employee = Employee.new(name: 'Bob', surname: 'Construtor', register_number: '362.164.860-71',
            email: 'novo@email.com', password: 'treina_dev13')

      expect(employee).not_to be_valid
    end

    it 'pré-cadastro é obrigatório' do
      owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
            email: 'adventure@time.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')

      employee = Employee.new(name: 'Bob', surname: 'Construtor', register_number: '362.164.860-71',
            email: 'bob@email.com', password: 'treina_dev13')

      expect(employee).not_to be_valid
    end
  end
end
