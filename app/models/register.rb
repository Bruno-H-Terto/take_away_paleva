class Register < ApplicationRecord
  belongs_to :order
  belongs_to :historical_order
end
