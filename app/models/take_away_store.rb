class TakeAwayStore < ApplicationRecord
  belongs_to :owner
  before_validation :generate_code, on: :create
  validates_with RegisterValidator, field: :register_number, length: 14, if: -> { register_number.present? }

  def business_name
    "#{trade_name} - #{corporate_name} - #{register_number}"
  end

  def street_number
    "#{street}, nº#{number}"
  end

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end
end
