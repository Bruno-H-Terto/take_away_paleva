class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :profile
  has_one :take_away_store, through: :profile

  before_validation :employee_associated, on: :create, if: -> {register_number.present? && email.present?}

  validates :name, :surname, :register_number, presence: true
  validates :register_number, uniqueness: true
  private

  def employee_associated
    profile = Profile.find_by(email: email, register_number: register_number)

    if profile.present?
      self.profile = profile
      self.profile.active!
    else
      errors.add(:profile, 'não associado a um Estabelecimento ativo')
    end
  end
end
