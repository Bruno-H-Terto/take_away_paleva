class Item < ApplicationRecord
  belongs_to :take_away_store
  has_many :portions
  has_one_attached :photo

  enum :status, { active: 0, inactive: 5 }

  validates :name, :description, presence: true
end
