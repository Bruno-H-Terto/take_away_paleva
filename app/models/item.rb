class Item < ApplicationRecord
  belongs_to :take_away_store
  has_many :portions, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :characteristics, through: :tags
  has_one_attached :photo, dependent: :destroy
  before_destroy :destroyed_by_association

  enum :status, { active: 0, inactive: 5 }

  validates :name, :description, presence: true
  validates :name, uniqueness: true

  def destroyed_by_association?
    true
  end
end
