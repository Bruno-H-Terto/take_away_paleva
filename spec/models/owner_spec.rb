require 'rails_helper'

RSpec.describe Owner, type: :model do
  context '#valid?' do
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

    it 'CPF deve ser único' do
      first_owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')
      second_owner = Owner.new(name: 'Jhon', surname: 'Doe', register_number: '402.793.150-58',
             email: 'jhon@doe.com', password: 'treina_dev13')

      expect(second_owner).not_to be_valid
    end
  end
end
