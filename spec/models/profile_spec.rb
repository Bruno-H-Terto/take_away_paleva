require 'rails_helper'

RSpec.describe Profile, type: :model do
  context '#valid?' do
    it { should belong_to(:take_away_store) }
    it { should have_one(:employee) }

    it 'todos os campos válidos' do
      owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
            email: 'adventure@time.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')

      profile = store.profiles.build(register_number: '362.164.860-71', email: 'bob@email.com')

      expect(profile).to be_valid
      expect(profile.save).to eq true
    end

    it 'email deve ser único entre Perfis' do
      owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
            email: 'adventure@time.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')

      profile = store.profiles.build(register_number: '750.209.140-88', email: 'bob@email.com')

      expect { profile.save }.not_to change { Profile.count }
    end

    it 'email deve ser único entre Perfis e Proprietários' do
      owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
            email: 'adventure@time.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')
      store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      Owner.create!(name: 'Harry', surname: 'Potter', register_number: '750.209.140-88',
            email: 'bob@email.com', password: 'treina_dev13')  

      profile = store.profiles.build(register_number: '285.665.390-10', email: 'bob@email.com')

      expect { profile.save }.not_to change { Profile.count }
    end

    it 'email deve ser único entre Perfis e Estabelecimentos' do
      owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
            email: 'adventure@time.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')
      other_owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '750.209.140-88',
            email: 'harry@email.com', password: 'treina_dev13')
      other_store = other_owner.create_take_away_store!(trade_name: 'Pastelaria', corporate_name: 'China LTDA',
            register_number: '82.165.933/0001-01', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-001', complement: 'Loja 1',
            email: 'bob@email.com')

      profile = store.profiles.build(register_number: '285.665.390-10', email: 'bob@email.com')

      expect { profile.save }.not_to change { Profile.count }
    end

    it 'CPF deve ser único entre Perfis e Proprietários' do
      first_owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')
      store = first_owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
             register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
             number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
             email: 'potter@email.com')
      second_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '362.164.860-71',
             email: 'jhon@doe.com', password: 'treina_dev13')

      profile = store.profiles.build(register_number: '362.164.860-71', email: 'bob@email.com')
   
      expect { profile.save }.not_to change { Profile.count }
    end

    it 'CPF deve ser único entre Perfis' do
      first_owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')
      store = first_owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
             register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
             number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
             email: 'potter@email.com')
      store.profiles.create!(register_number: '362.164.860-71', email: 'doe@email.com')

      profile = store.profiles.build(register_number: '362.164.860-71', email: 'bob@email.com')
   
      expect { profile.save }.not_to change { Profile.count }
    end
  end
end
