require 'rails_helper'

RSpec.describe Register, type: :model do
  context '#valid?' do
    it {should belong_to(:order)}
    it {should belong_to(:historical_order)}
  end
end
