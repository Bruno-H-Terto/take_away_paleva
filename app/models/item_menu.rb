class ItemMenu < ApplicationRecord
  belongs_to :item
  belongs_to :menu

  validates :item, uniqueness: { scope: :menu }
  before_validation :item_must_be_same_store_of_menu

  private

  def item_must_be_same_store_of_menu
    if item&.take_away_store != menu&.take_away_store
      errors.add(:item, 'deve ser do mesmo Estabelecimento')
    end
  end
end