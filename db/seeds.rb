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
    email: 'quadribol@email.com', password: 'treina_dev13')
store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
    register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
    number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
    email: 'potter@email.com')
BusinessHour.day_of_weeks.each do |key, _|
  store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
    close_time: '17:00')
end