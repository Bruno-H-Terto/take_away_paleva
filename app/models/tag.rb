class Tag < ApplicationRecord
  belongs_to :item
  belongs_to :characteristic
  accepts_nested_attributes_for :characteristic
end
