class Portion < ApplicationRecord
  belongs_to :item
  validates :option_name, :value, presence: true
  validates :option_name, length: {maximum: 15, option_name: 'deve ter no máximo 15 caracteres'}
  validates :value, numericality: {only_integer: true}
  validates :value, numericality: {greater_than_or_equal_to: 100, message: 'Preço mínimo de R$ 1,00'}
  before_destroy :prevent_destroy, unless: :destroyed_by_association


  def menu_option_name
    "#{option_name} - #{formated_value}"
  end

  def formated_value
    price = attribute_in_database(:value).to_s.insert(-3, ',')
    "R$ #{price}"
  end

  def item_name
    "#{item.name} - porção #{option_name}"
  end

  def created_date_portion
    "Porção cadastrada em #{I18n.l(created_at, format: "%d/%m/%y")}"
  end


  private

  def prevent_destroy
    self.errors[:base] << 'Não é permitido a exclusão de porções de um item'
    throw :abort
  end
end
