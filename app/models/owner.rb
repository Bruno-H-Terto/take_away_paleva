class Owner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :register_number, :name, :surname, presence: true
  validates :register_number, uniqueness: true
  validates_with RegisterValidator, field: :register_number, length: 11, if: -> { register_number.present? }
end
