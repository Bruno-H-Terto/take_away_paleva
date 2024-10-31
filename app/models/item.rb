class Item < ApplicationRecord
  belongs_to :take_away_store
  has_one_attached :photo

  validates :name, :description, presence: true
end
