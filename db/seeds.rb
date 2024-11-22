# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
    email: 'meninobruxo@email.com', password: 'treina_dev13')
store = owner.create_take_away_store!(trade_name: 'Pedra Filosofal', corporate_name: 'Hogwarts LTDA',
    register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
    number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
    email: 'potter@email.com')
BusinessHour.day_of_weeks.each do |key, _|
store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
  close_time: '17:00')
end

hamburguer_1 = store.items.create!(name: 'Hambúrguer caseiro simples', description: 'Uma opção deliciosa para a hora do lanche, que oferece uma maneira divertida e criativa de saborear um dos pratos mais populares do mundo.',
  calories: 480, type: 'Dish')
hamburguer_1.photo.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'hamburguer-2.jpeg')), filename: 'hamburguer-2.jpeg')
hamburguer_1.portions.create!(option_name: 'Média', value: 6000)

hamburguer_2 = store.items.create!(name: 'Podrão da esquina', description: 'Artesanal, tradicional da cidade de Juiz de Fora.', calories: 700, type: 'Dish')
hamburguer_2.photo.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'hamburguer.jpg')), filename: 'hamburguer.jpg')
hamburguer_2.portions.create!(option_name: 'Grande', value: 3000)

vinho_tinto = store.items.create!(name: 'Paine Cabernet Sauvignon', description: 'Um Cabernet Sauvignon elaborado no Vale Central chileno pela vinícola Viñedos y Frutales (VyF).', calories: 85, type: 'Beverage')
vinho_tinto.photo.attach(io: File.open(Rails.root.join('spec', 'support', 'files', 'vinho-tinto.jpeg')), filename: 'vinho-tinto.jpeg')
vinho_tinto.portions.create!(option_name: '750ml', value: 4000)

fast_food = store.menus.create!(name: 'Fast Food')
fast_food.item_menus.create!(item: hamburguer_1)
fast_food.item_menus.create!(item: hamburguer_2)

vinho = store.menus.create!(name: 'Vinhos')
vinho.item_menus.create!(item: vinho_tinto)

alcoholic = store.characteristics.create!(quality_name: 'Alcoólico')
snack = store.characteristics.create!(quality_name: 'Lanche em família')
special = store.characteristics.create!(quality_name: 'Especial da casa')

hamburguer_1.tags.create!(characteristic: snack)
hamburguer_2.tags.create!(characteristic: special)
vinho_tinto.tags.create!(characteristic: alcoholic)

