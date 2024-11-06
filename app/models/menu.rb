class Menu < ApplicationRecord
  belongs_to :take_away_store
  has_many :item_menus
  has_many :items, through: :item_menus

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
end
