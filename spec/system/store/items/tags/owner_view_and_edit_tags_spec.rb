require 'rails_helper'

describe 'Proprietário acessa listagem de tags registradas' do
  it 'e vê listagem completa' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Pastel Dev', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
          close_time: '17:00')
    end
    store.characteristics.create!(quality_name: 'Doce')
    store.characteristics.create!(quality_name: 'Salgado')
    store.characteristics.create!(quality_name: 'Vegano')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Marcadores'

    expect(page).to have_content 'Gerencie seus marcadores'
    expect(page).to have_content 'Novo Marcador'
    expect(page).to have_content 'Doce'
    expect(page).to have_content 'Salgado'
    expect(page).to have_content 'Vegano'
  end

  it 'e não localiza marcadores cadastrados para o próprio Estabelecimento' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Pastel Dev', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
          close_time: '17:00')
    end
    other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '307.331.850-02',
        email: 'jhon@email.com', password: 'treina_dev13')
    other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria Top', corporate_name: 'Pastel LTDA',
        register_number: '92.303.111/0001-95', phone_number: '(11) 88888-0000', street: 'Av. Getúlio Vargas',
        number: '91', district: 'Centro', city: 'São Paulo', state: 'SP', zip_code: '12000-000', complement: 'Loja 1',
        email: 'pateltop@email.com')
    other_store.characteristics.create!(quality_name: 'Doce')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Marcadores'

    expect(page).to have_content 'Não foram localizados marcadores cadastrados'
    expect(page).not_to have_content 'Doce'
  end

  it 'e cadastra um novo marcador' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Pastel Dev', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
          close_time: '17:00')
    end

    login_as owner, scope: :owner
    visit root_path
    click_on 'Marcadores'
    fill_in 'Marcador', with: 'Salgado'
    click_on 'Criar Marcador'

    expect(page).to have_content 'Marcador Salgado criado com sucesso!'
    expect(page).to have_content 'Salgado'
  end

  it 'e falha ao não inserir um campo válido' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Pastel Dev', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
          close_time: '17:00')
    end

    login_as owner, scope: :owner
    visit root_path
    click_on 'Marcadores'
    fill_in 'Marcador', with: ''
    click_on 'Criar Marcador'

    expect(page).to have_content 'Não foi possível criar seu marcador'
    expect(store.characteristics.count).to eq 0
  end

  it 'e edita um marcador cadastrado' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Pastel Dev', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
          close_time: '17:00')
    end
    store.characteristics.create!(quality_name: 'salgado')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Marcadores'
    click_on 'salgado'
    fill_in 'Marcador', with: 'Salgado'
    click_on 'Atualizar Marcador'

    expect(page).to have_content 'Marcador atualizado com sucesso!'
    expect(page).to have_content 'Sem items associados'
    expect(page).to have_content 'Salgado'
    expect(page).not_to have_content 'salgado'
  end

  it 'e falha ao não incluir informações obrigatórias' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Pastel Dev', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
          close_time: '17:00')
    end
    store.characteristics.create!(quality_name: 'salgado')

    login_as owner, scope: :owner
    visit root_path
    click_on 'Marcadores'
    click_on 'salgado'
    fill_in 'Marcador', with: ''
    click_on 'Atualizar Marcador'

    expect(page).to have_content 'Não foi possível atualizar seu Marcador'
  end

  it 'e falha ao não incluir informações obrigatórias' do
    owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
        email: 'quadribol@email.com', password: 'treina_dev13')
    store = owner.create_take_away_store!(trade_name: 'Pastel Dev', corporate_name: 'Hogwarts LTDA',
        register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
        number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
        email: 'potter@email.com')
    BusinessHour.day_of_weeks.each do |key, _|
      store.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
          close_time: '17:00')
    end
    item_1 = store.items.create!(name: 'Pizza', description: 'Quatro queijos', calories: 120, type: 'Dish')
    item_2 = store.items.create!(name: 'Hamburguer', description: 'Artesanal', calories: 100, type: 'Dish')
    item_3 = store.items.create!(name: 'Sorvete', description: 'Chocolate', calories: 100, type: 'Dish')
    characteristic = store.characteristics.create!(quality_name: 'Salgado')
    item_1.tags.create!(characteristic: characteristic)
    item_2.tags.create!(characteristic: characteristic)

    login_as owner, scope: :owner
    visit root_path
    click_on 'Marcadores'
    click_on 'Salgado'

    within '#list_associeted_items' do
      expect(page).to have_content 'Pizza'
      expect(page).to have_content 'Hamburguer'
      expect(page).not_to have_content 'Sorvete'
    end
  end
end