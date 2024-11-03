require 'rails_helper'

RSpec.describe Characteristic, type: :model do
  context '#valid?' do
    it { should have_many(:tags) }

    it 'todos os campos válidos' do
      characteristic = Characteristic.new(quality_name: 'Salgado')

      expect(characteristic).to be_valid
    end

    it 'marcador é obrigatório' do
      characteristic = Characteristic.new(quality_name: '')

      expect(characteristic).not_to be_valid
    end

    it 'marcador deve ser única' do
      Characteristic.create!(quality_name: 'Salgado')
      characteristic = Characteristic.new(quality_name: 'Salgado')

      expect(characteristic).not_to be_valid
    end

    it 'é case sensitive' do
      Characteristic.create!(quality_name: 'Salgado')
      characteristic = Characteristic.new(quality_name: 'salgado')

      expect(characteristic).not_to be_valid
    end
  end
end
