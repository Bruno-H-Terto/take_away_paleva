require 'rails_helper'

RSpec.describe TakeAwayStore, type: :model do
  context '#valid?' do
    it { should belong_to(:owner) }
    it { should have_many(:items) }
    it { should have_many(:orders) }

    it 'todos os campos válidos' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).to be_valid
    end

    it 'Nome fantasia é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: '', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'Razão Social é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: '',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'CNPJ é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'CNPJ deve ser válido' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-00', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'telefone deve ter entre 10 e 11 números' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-00000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Dow', register_number: '759.942.990-57',
            email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.build_take_away_store(trade_name: 'Pastelaria', corporate_name: 'China LTDA',
            register_number: '82.165.933/0001-01', phone_number: '(11) 98800-00', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
      expect(other_store).not_to be_valid
    end

    it 'telefone deve ter formato válido' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 9 8 8 00-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Dow', register_number: '759.942.990-57',
            email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.build_take_away_store(trade_name: 'Pastelaria', corporate_name: 'China LTDA',
            register_number: '82.165.933/0001-01', phone_number: '(11) 98800-00a0', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'Logradouro é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: '',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'número é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'bairro é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: '', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'cidade é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: '', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'estado é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: '', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'CEP é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'CEP deve ter formato válido' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '1100-0000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).not_to be_valid
    end

    it 'endereço não pode ser compartilhado' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '759.942.990-57',
            email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.build_take_away_store(trade_name: 'Pastelaria', corporate_name: 'China LTDA',
            register_number: '82.165.933/0001-01', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'harry@email.com')

      expect(store).to be_valid
      expect(other_store).not_to be_valid
    end

    it 'complemento é opcional' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
            email: 'potter@email.com')

      expect(store).to be_valid
    end

    it 'E-mail é obrigatório' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: '')

      expect(store).not_to be_valid
    end

    it 'E-mail deve ser único entre Estabelecimentos' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Dow', register_number: '759.942.990-57',
            email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.build_take_away_store(trade_name: 'Pastelaria', corporate_name: 'China LTDA',
            register_number: '82.165.933/0001-01', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '91', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).to be_valid
      expect(other_store).not_to be_valid
    end

    it 'email deve ser único entre Estabelecimentos e Funcionários' do
      first_owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')
      first_store = first_owner.create_take_away_store!(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
             register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
             number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
             email: 'potter@email.com')
      first_store.profiles.create!(register_number: '362.164.860-71', email: 'bob@email.com')
      employee = Employee.create!(name: 'Bob', surname: 'Doe', register_number: '362.164.860-71',
             email: 'bob@email.com', password: 'treina_dev13')

      second_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '750.209.140-88',
             email: 'jhon@email.com', password: 'treina_dev13')
      second_store = second_owner.build_take_away_store(trade_name: 'Pastelaria', corporate_name: 'China LTDA',
              register_number: '82.165.933/0001-01', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
              number: '91', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
              email: 'bob@email.com')
          
      expect(second_store.save).to be_falsey
      expect(TakeAwayStore.count).to eq 1
    end

    it 'email deve ser único entre Estabelecimentos e Proprietários' do
      first_owner = Owner.create!(name: 'Finn', surname: 'Jake', register_number: '402.793.150-58',
             email: 'adventure@time.com', password: 'treina_dev13')

      second_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '750.209.140-88',
             email: 'jhon@email.com', password: 'treina_dev13')
      store = second_owner.build_take_away_store(trade_name: 'Pizza Dev', corporate_name: 'Hogwarts LTDA',
             register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
             number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: '',
             email: 'adventure@time.com')
   
      expect(store.save).to be_falsey
      expect(TakeAwayStore.count).to eq 0
    end

    it 'E-mail deve ter formato válido' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.build_take_away_store(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email')

      expect(store).not_to be_valid
    end

    it 'CNPJ deve ser único' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '759.942.990-57',
            email: 'jhon@email.com', password: 'treina_dev13')
      other_store = other_owner.build_take_away_store(trade_name: 'Pastelaria', corporate_name: 'China LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-00a0', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(other_store).not_to be_valid
    end

    it 'código é gerado automáticamente' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store.code.present?).to eq true
    end

    it 'código deve ser único' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      other_owner = Owner.create!(name: 'Jhon', surname: 'Doe', register_number: '759.942.990-57',
            email: 'jhon@email.com', password: 'treina_dev13')
      allow(SecureRandom).to receive(:alphanumeric).with(6).and_return('ABC123')
      other_store = other_owner.create_take_away_store(trade_name: 'Pastelaria', corporate_name: 'China LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-00a0', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')

      expect(store).to be_valid
      expect(other_store).not_to be_valid
    end

    it 'código não se altera após atualizações' do
      owner = Owner.create!(name: 'Harry', surname: 'Potter', register_number: '402.793.150-58',
            email: 'quadribol@email.com', password: 'treina_dev13')
      store = owner.create_take_away_store!(trade_name: 'Grifinória', corporate_name: 'Hogwarts LTDA',
            register_number: '76.898.265/0001-10', phone_number: '(11) 98800-0000', street: 'Beco diagonal',
            number: '13', district: 'Bolsão', city: 'Hogsmeade', state: 'SP', zip_code: '11000-000', complement: 'Loja 1',
            email: 'potter@email.com')
      code = store.code
      store.update!(trade_name: 'Novo nome')

      expect(store.code).to eq code
    end
  end
end
