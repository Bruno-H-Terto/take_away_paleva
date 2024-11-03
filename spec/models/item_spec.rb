require 'rails_helper'

RSpec.describe Item, type: :model do
  context '#valid?' do
    it { should belong_to(:take_away_store) }

    it 'todos os campos válidos' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      dish_photo = fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'pizza-1.jpg'))
      dish = store.items.build(name: 'Vinho tinto', description: '750ml', calories: 50, photo: dish_photo, type: 'Dish')
      drink_photo = fixture_file_upload(Rails.root.join('spec', 'support', 'files', 'pizza-1.jpg'))
      drink = store.items.build(name: 'Pizza', description: 'Quatro queijos', calories: 80, photo: drink_photo, type: 'Beverage')

      expect(dish).to be_valid
      expect(drink).to be_valid
    end

    it 'foto é opcional' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      drink = store.items.build(name: 'Vinho tinto', description: '750ml', calories: 50, type: 'Beverage')
      dish = store.items.build(name: 'Pizza', description: 'Quatro queijos', calories: 80, type: 'Dish')

      expect(dish).to be_valid
      expect(drink).to be_valid
    end

    it 'nome é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      dish = store.items.build(name: '', description: '750ml', calories: 50, type: 'Dish')
      drink = store.items.build(name: '', description: 'Quatro queijos', calories: 80, type: 'Beverage')

      expect(dish).not_to be_valid
      expect(drink).not_to be_valid
    end

    it 'nome deve ser único' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      store.items.create!(name: 'Coca-Cola', description: '750ml', calories: 50, type: 'Dish')
      drink = store.items.build(name: 'Coca-Cola', description: '750ml', calories: 50, type: 'Dish')

      expect(drink).not_to be_valid
    end

    it 'descrição é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      dish = store.items.build(name: 'Vinho tinto', description: '', calories: 50, type: 'Dish')
      drink = store.items.build(name: 'Pizza', description: '', calories: 80, type: 'Beverage')

      expect(dish).not_to be_valid
      expect(drink).not_to be_valid
    end


    it 'calorias é opcional' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      dish = store.items.build(name: 'Vinho tinto', description: '750ml', calories: '', type: 'Dish')
      drink = store.items.build(name: 'Pizza', description: 'Quatro queijos', calories: '', type: 'Beverage')

      expect(dish).to be_valid
      expect(drink).to be_valid
    end
  end
end
