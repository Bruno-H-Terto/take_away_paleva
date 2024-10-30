require 'rails_helper'

describe 'Proprietário edita os dados de seu estabelecimento' do
  it 'a partir da página inicial' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')
          
    login_as owner, scope: :owner
    visit root_path
    click_on 'My Store'

    expect(page).to have_content 'Grifinória - Hogwarts LTDA - 76.898.265/0001-10'
    expect(page).to have_content 'Beco diagonal, nº 13'
    expect(page).to have_content 'Hogsmeade, SP'
    expect(page).to have_content 'Bolsão'
    expect(page).to have_content '(11) 98800-0000'
  end
end