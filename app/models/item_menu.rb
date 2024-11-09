class ItemMenu < ApplicationRecord
  belongs_to :item
  belongs_to :menu

  validates :item, uniqueness: { scope: :menu }
  before_validation :item_must_be_same_store_of_menu
  before_validation :item_must_have_a_portion

  private

  def item_must_be_same_store_of_menu
    if item&.take_away_store != menu&.take_away_store
      errors.add(:item, 'deve ser do mesmo Estabelecimento')
    end
  end

  def item_must_have_a_portion
    if item && item.portions.none?
      errors.add(:item, 'deve ter ao menos uma porção cadastrada')
    end
  end
end