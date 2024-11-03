class Tag < ApplicationRecord
  belongs_to :item
  belongs_to :characteristic
  accepts_nested_attributes_for :characteristic
  before_validation :tag_must_be_uniq_for_same_item, if: -> {item.present?}

  validate :characteristic_quality_name_present

  private

  def characteristic_quality_name_present
    if characteristic && characteristic.quality_name.blank?
      errors.add(:characteristic, 'deve ter um marcador presente')
    end
  end

  def tag_must_be_uniq_for_same_item
    if item.tags.exists?(characteristic: characteristic)
      errors.add(:tag, 'deve ser única para o mesmo produto')
    end
  end
end
