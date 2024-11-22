class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def money_value(value)
    money = value.to_s.insert(-3, ',')
    money = money.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
    "R$ #{money}"
  end

  private
  
  def name_must_be_text
    if name.present? && name[0].match?(/\d/)
      errors.add(:name, 'não deve começar com números')
    end
  end
end
