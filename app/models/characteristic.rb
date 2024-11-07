class Characteristic < ApplicationRecord
  has_many :tags, dependent: :destroy
  has_many :items, through: :tags
  belongs_to :take_away_store
  validate :quality_name_must_be_uniq_for_same_store, if: -> {quality_name.present?}
  validates :quality_name, presence: true


  private

  def quality_name_must_be_uniq_for_same_store
    if take_away_store.characteristics.where('lower(quality_name) = ?', quality_name.downcase).where.not(id: id).exists?
      errors.add(:quality_name, 'já está em uso')
    end
  end
end
