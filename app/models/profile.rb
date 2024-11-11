class Profile < ApplicationRecord
  belongs_to :take_away_store
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

  def register_number_default_format
    self.register_number.gsub(/[\/.-]/, '')
  end
end
