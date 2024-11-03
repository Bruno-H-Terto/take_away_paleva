class Tag < ApplicationRecord
  belongs_to :item
  belongs_to :characteristic
  accepts_nested_attributes_for :characteristic


  validate :characteristic_quality_name_present

  private

  def characteristic_quality_name_present
    if characteristic && characteristic.quality_name.blank?
      errors.add(:characteristic, 'deve ter um marcador presente')
    end
  end
end
