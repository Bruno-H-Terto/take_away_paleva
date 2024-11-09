require 'rails_helper'

RSpec.describe ItemMenu, type: :model do
  context '#valid?' do
    it {should belong_to(:item)}
    it {should belong_to(:menu)}

    it 'todos os campos válidos' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      menu = store.menus.create!(name: 'Café da manhã')
      dish = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: '', type: 'Dish')
      dish.portions.create!(option_name: 'Pequena', value: 13000)

      item_menu = ItemMenu.new(item: dish, menu: menu)

      expect(item_menu).to be_valid
    end

    it 'item deve ter ao menos uma porão cadastrada' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      menu = store.menus.create!(name: 'Café da manhã')
      dish = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: '', type: 'Dish')

      item_menu = ItemMenu.new(item: dish, menu: menu)

      expect(item_menu).not_to be_valid
    end

    it 'item deve ser único para o mesmo Estabelecimento' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      menu = store.menus.create!(name: 'Café da manhã')
      dish = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: '', type: 'Dish')
      dish.portions.create!(option_name: 'Pequena', value: 13000)
      ItemMenu.create!(item: dish, menu: menu)

      item_menu = ItemMenu.new(item: dish, menu: menu)

      expect(item_menu).not_to be_valid
    end

    it 'item pode estar presente em diferentes menus' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      menu = store.menus.create!(name: 'Café da manhã')
      other_menu = store.menus.create!(name: 'Café da tarde')
      dish = store.items.create!(name: 'Vinho tinto', description: '750ml', calories: '', type: 'Dish')
      dish.portions.create!(option_name: 'Pequena', value: 13000)

      item_menu = ItemMenu.new(item: dish, menu: menu)
      other_item_menu = ItemMenu.new(item: dish, menu: other_menu)

      expect(item_menu).to be_valid
      expect(other_item_menu).to be_valid
    end

    it 'item e menu devem ser do mesmo Estabelecimento' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      menu = store.menus.create!(name: 'Café da manhã')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
            email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
            register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
            number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
            email: 'pateltop@email.com')
      dish = other_store.items.create!(name: 'Vinho tinto', description: '750ml', calories: '', type: 'Dish')
      dish.portions.create!(option_name: 'Pequena', value: 13000)

      item_menu = ItemMenu.new(item: dish, menu: menu)

      expect(item_menu).not_to be_valid
    end
  end
end
