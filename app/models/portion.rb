class Portion < ApplicationRecord
  belongs_to :item
  validates :option_name, :value, presence: true

  def menu_option_name
    "#{option_name} - #{formated_value(value)}"
  end

  def formated_value(value = self.value)
    price = value.to_s.insert(-3, ',')
    "R$ #{price}"
  end

  def item_name
    "#{item.name} - porção #{option_name}"
  end

  def upload_date
    "Valor cadastrado em #{I18n.l(created_at, format: "%d/%m/%y")}"
  end
end
