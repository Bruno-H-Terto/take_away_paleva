class Owner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :register_number, :name, :surname, presence: true
  validates :register_number, uniqueness: true
  validates_with RegisterValidator, field: :register_number, length: 11, if: -> { register_number.present? }

  has_one :take_away_store
  has_many :items, through: :take_away_store
  has_many :menus, through: :take_away_store

  before_save :ensure_unique_field

  def full_name
    "#{name} #{surname}"
  end

  def card_name
    "#{name.split(' ').first[0].upcase}#{surname.split(' ').first[0].upcase}"
  end

  private

  
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
