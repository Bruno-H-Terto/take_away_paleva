class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def money_value(value)
    money = value.to_s.insert(-3, ',')
    money = money.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
    "R$ #{money}"
  end
end
