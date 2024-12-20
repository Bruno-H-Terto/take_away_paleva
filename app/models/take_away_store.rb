class TakeAwayStore < ApplicationRecord
  belongs_to :owner
  has_many :items, class_name: 'Item'
  has_many :business_hours
  has_many :menus
  has_many :characteristics
  has_many :orders
  has_many :profiles
  has_many :historical_orders, through: :orders
  accepts_nested_attributes_for :business_hours

  before_validation :generate_code, on: :create
  after_create :ensure_unique_field
  validates :trade_name, :corporate_name, :register_number, :phone_number, :email,
            :street, :number, :state, :district, :city, :zip_code, presence: true
  validate :state_must_be_an_uf
  validates :register_number, uniqueness: true 
  validate :address_must_be_uniq
  validates :email, format: { 
    with: /\A[a-z0-9]+([\.\-_][a-z0-9]+)*@[a-z0-9]+(-[a-z0-9]+)*(\.[a-z]{2,})+\z/i,
    message: 'deve ser em um formato válido'
  }
  validates :email, uniqueness: true
  validates :zip_code, format: { with: /\A(\d){5}[-]?(\d){3}\z/, message: 'deve ser em um formato válido' }
  validates_with RegisterValidator, field: :register_number, length: 14, if: -> { register_number.present? }
  validates_with PhoneValidator, field: :phone_number, if: -> { phone_number.present? }

  STATES = [
    "AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", 
    "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", 
    "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"
  ].freeze

  def business_name
    "#{trade_name} - #{corporate_name} - #{register_number}"
  end

  def street_number
    "#{street}, nº #{number}"
  end

  def search_query(query)
    self.items.where('name LIKE ? OR description LIKE ?', "%#{query}%", "%#{query}%").order(name: :asc)
  end

  private

  def state_must_be_an_uf
    unless STATES.include?(state)
      errors.add(:state, 'deve ser uma UF')
    end
  end

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end

  def address_must_be_uniq
    if TakeAwayStore.where.not(id: id).where(zip_code: zip_code, number: number).exists?
      errors.add(:base, 'Endereço já está em uso')
    end
  end  

  def ensure_unique_field
    formatted_register_number = register_number.gsub(/\D/, '') if register_number.present?
  
    if UniqueField.exists?(email: email)
      errors.add(:email, 'já está em uso')
      raise ActiveRecord::Rollback
    elsif UniqueField.exists?(register_number: formatted_register_number)
      errors.add(:register_number, 'já está em uso')
      raise ActiveRecord::Rollback
    else
      UniqueField.create!(email: email, register_number: register_number)
    end
  end
end
