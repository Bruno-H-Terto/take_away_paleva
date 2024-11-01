class Portion < ApplicationRecord
  belongs_to :item, dependent: :destroy

  def menu_option_name
    "#{option_name} - R$ #{formated_value(value)}"
  end

  def formated_value(value)
    price = value.to_s.insert(-3, ',')
  end
end
