class Characteristic < ApplicationRecord
  has_many :tags, dependent: :destroy
  validates :quality_name, uniqueness: true
  validates :quality_name, presence: true
end
