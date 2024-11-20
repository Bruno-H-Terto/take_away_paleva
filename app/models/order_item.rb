class OrderItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item
  belongs_to :portion
  belongs_to :order

  before_validation :order_specifications_must_be_same_store
  before_create :add_value_to_order

  validates :quantity, presence: true

  private

  def order_specifications_must_be_same_store
    specifications = [menu, item, portion]
    if specifications.all?(&:present?) &&
       (menu.take_away_store != item.take_away_store || item != portion.item)
      errors.add(:base, 'Especificações do pedido devem ser do mesmo Estabelecimento e Produto')
    end
  end

  def add_value_to_order
    total = order.total 
    total += self.portion.value * self.quantity.to_i
    order.update(total: total)
  end
end
