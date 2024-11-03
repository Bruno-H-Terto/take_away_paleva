class Characteristic < ApplicationRecord
  has_many :tags, dependent: :destroy
  validates :quality_name, uniqueness: { case_sensitive: false }
  validates :quality_name, presence: true
end
