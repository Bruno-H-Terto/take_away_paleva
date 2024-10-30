class TakeAwayStore < ApplicationRecord
  belongs_to :owner
  before_validation :generate_code, on: :create
  validates :trade_name, :corporate_name, :register_number, :phone_number, :email,
            :street, :number, :state, :district, :city, :zip_code, presence: true
  validates :register_number, uniqueness: true 
  validates :email, format: { 
    with: /\A[a-z0-9]+([\.\-_][a-z0-9]+)*@[a-z0-9]+(-[a-z0-9]+)*(\.[a-z]{2,})+\z/i,
    message: 'deve ser em um formato válido'
  }
  validates :zip_code, format: { with: /\A(\d){5}[-](\d){3}\z/, message: 'deve ser em um formato válido' }
  validates_with RegisterValidator, field: :register_number, length: 14, if: -> { register_number.present? }
  validates_with PhoneValidator, field: :phone_number, if: -> { phone_number.present? }

  def business_name
    "#{trade_name} - #{corporate_name} - #{register_number}"
  end

  def street_number
    "#{street}, nº #{number}"
  end

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end
end
