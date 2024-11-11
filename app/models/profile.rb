class Profile < ApplicationRecord
  belongs_to :take_away_store
  has_one :unique_field, as: :registrable
  has_many :employees

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

  after_create :ensure_unique_field

  def register_number_default_format
    self.register_number.gsub(/[\/.-]/, '')
  end

  private

  def ensure_unique_field
    if UniqueField.exists?(email: email)
      errors.add(:email, 'já está em uso')
      raise ActiveRecord::Rollback
    elsif UniqueField.exists?(register_number: register_number)
      errors.add(:register_number, 'já está em uso')
      raise ActiveRecord::Rollback
    else
      self.unique_field = UniqueField.create(email: email, register_number: register_number, registrable: self)
    end
  end
end
