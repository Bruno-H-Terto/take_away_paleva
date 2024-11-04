class Characteristic < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :items, through: :tags
  validates :quality_name, uniqueness: { case_sensitive: false }
  validates :quality_name, presence: true
end
