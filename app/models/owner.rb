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

  def full_name
    "#{name} #{surname}"
  end

  def card_name
    "#{name.split(' ').first[0].upcase}#{surname.split(' ').first[0].upcase}"
  end
end
