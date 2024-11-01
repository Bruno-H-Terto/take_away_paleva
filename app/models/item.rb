class Item < ApplicationRecord
  belongs_to :take_away_store
  has_many :portions, dependent: :destroy
  has_one_attached :photo, dependent: :destroy

  enum :status, { active: 0, inactive: 5 }

  validates :name, :description, presence: true
end
