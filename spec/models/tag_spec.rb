require 'rails_helper'

RSpec.describe Tag, type: :model do
  context '#valid?' do
    it { should belong_to(:item) }
    it { should belong_to(:characteristic) }

    it 'todos os campos válidos' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      characteristic = Characteristic.create!(quality_name: 'Alcoólico', take_away_store: store)

      tag = Tag.new(item: drink, characteristic: characteristic)

      expect(tag).to be_valid
    end

    it 'deve ser única para o mesmo item' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      drink = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      other_drink = store.items.create!(name: 'Vinho branco', description: '750ml', calories: 50, type: 'Beverage')
      characteristic = store.characteristics.create!(quality_name: 'Alcoólico')
      Tag.create!(item: drink, characteristic: characteristic)

      drink_tag = Tag.new(item: drink, characteristic: characteristic)
      other_drink_tag = Tag.new(item: other_drink, characteristic: characteristic)

      expect(drink_tag).not_to be_valid
      expect(other_drink_tag).to be_valid
    end
  end
end
