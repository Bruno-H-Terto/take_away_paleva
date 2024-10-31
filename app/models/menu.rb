class Menu < ApplicationRecord
  belongs_to :take_away_store
  has_many_attached :photos

  validates :name, :description, presence: true
end
