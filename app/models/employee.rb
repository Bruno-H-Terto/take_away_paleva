class Employee < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Devise::Models::Authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :profile
  has_one :take_away_store, through: :profile

  before_validation :employee_associated, on: :create

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
