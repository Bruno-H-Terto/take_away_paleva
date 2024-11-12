class OrderItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item
  belongs_to :portion
  belongs_to :order

  before_validation :order_specifications_must_be_same_store

  validates :quantity, presence: true

  private

  def order_specifications_must_be_same_store
    specifications = [menu, item, portion]
    if specifications.all?(&:present?) &&
       (menu.take_away_store != item.take_away_store || item != portion.item)
      errors.add(:base, 'Especificações do pedido devem ser do mesmo Estabelecimento')
    end
  end
end
