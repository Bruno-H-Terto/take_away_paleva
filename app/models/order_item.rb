class OrderItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item
  belongs_to :portion
  belongs_to :order

  validates :quantity, presence: true
end
