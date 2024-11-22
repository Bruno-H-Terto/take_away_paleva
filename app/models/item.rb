class Item < ApplicationRecord
  belongs_to :take_away_store
  has_many :portions
  has_many :tags
  has_many :characteristics, through: :tags
  has_many :historics
  has_many :item_menus
  has_many :menus, through: :item_menus
  has_one_attached :photo
  before_destroy :destroy_unauthorized!

  enum :status, { active: 0, inactive: 5 }

  validates :name, :description, presence: true
  validate :name_must_be_text
  before_validation :name_must_be_uniqueness_for_same_store

  private

  def destroy_unauthorized!
    errors.add(:base, 'Não está autorizado a exlusão de items')
    throw :abort
  end

  def name_must_be_uniqueness_for_same_store
    if Item.where(name: name, take_away_store: take_away_store).where.not(id: id).exists?
      errors.add(:name, 'já está em uso')
    end
  end
end
