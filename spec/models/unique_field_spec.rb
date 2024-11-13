require 'rails_helper'

RSpec.describe UniqueField, type: :model do
  context '#valid?' do
    it 'CPF e email devem ser únicos' do
      UniqueField.create!(register_number: '402.793.150-58', email: 'jhon@email.com')

      field = UniqueField.new(register_number: '402.793.150-58', email: 'jhon@email.com')

      expect(field).not_to be_valid
    end

    it 'CPF deve ser único' do
      UniqueField.create!(register_number: '402.793.150-58', email: 'jhon@email.com')

      field = UniqueField.new(register_number: '402.793.150-58', email: 'bob@email.com')

      expect(field).not_to be_valid
    end

    it 'E-mail deve ser único' do
      UniqueField.create!(register_number: '402.793.150-58', email: 'jhon@email.com')

      field = UniqueField.new(register_number: '750.209.140-88', email: 'jhon@email.com')

      expect(field).not_to be_valid
    end
  end
end
