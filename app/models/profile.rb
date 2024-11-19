class Profile < ApplicationRecord
  belongs_to :take_away_store
  has_one :employee

  enum :status, {
    waiting_confirmation: 0,
    active: 5
  }

  validates :register_number, :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { 
    with: /\A[a-z0-9]+([\.\-_][a-z0-9]+)*@[a-z0-9]+(-[a-z0-9]+)*(\.[a-z]{2,})+\z/i,
    message: 'deve ser em um formato válido'
  }, if: -> {email.present?}
  validates_with RegisterValidator, field: :register_number, length: 11, if: -> { register_number.present? }

  before_create :ensure_unique_field

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
