require 'rails_helper'

RSpec.describe Beverage, type: :model do
  it { expect(Beverage).to be < Item }
end
