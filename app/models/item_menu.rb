class ItemMenu < ApplicationRecord
  belongs_to :item
  belongs_to :menu

  validates :item, uniqueness: { scope: :menu }
end