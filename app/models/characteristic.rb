class Characteristic < ApplicationRecord
  has_many :tags, dependent: :destroy
  validates :quality_name, uniqueness: true
end
