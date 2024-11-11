class UniqueField < ApplicationRecord
  before_validation :formatted_register_number

  validates :register_number, :email, uniqueness: true 


  private

  def formatted_register_number
    self.register_number = register_number.gsub(/\D/, '') if register_number.present?
  end  
end
