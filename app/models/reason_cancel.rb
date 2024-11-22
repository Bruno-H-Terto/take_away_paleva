class ReasonCancel < ApplicationRecord
  belongs_to :order

  validates :information, presence: true
end
