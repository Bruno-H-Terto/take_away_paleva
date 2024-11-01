require 'rails_helper'

RSpec.describe Dish, type: :model do
  it { expect(Dish).to be < Item }
end
