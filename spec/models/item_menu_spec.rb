require 'rails_helper'

RSpec.describe ItemMenu, type: :model do
  context '#valid?' do
    it {should belong_to(:item)}
    it {should belong_to(:menu)}

    it 'todos os campos válidos' do

    end
  end
end
