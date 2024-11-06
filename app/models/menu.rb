class Menu < ApplicationRecord
  belongs_to :take_away_store
  has_many :item_menus
  has_many :items, through: :item_menus

  validates :name, presence: true
  validate :name_must_be_uniq_for_same_store, if: -> {take_away_store.present?}

  private

  def name_must_be_uniq_for_same_store
    if take_away_store&.menus&.where('lower(name) = ?', name.downcase).where.not(id: id).exists?
      errors.add(:name, 'já está em uso para esta loja')
    end
  end
end
