class Portion < ApplicationRecord
  belongs_to :item
  has_many :historics, dependent: :destroy
  validates :option_name, :value, presence: true
  validates :option_name, length: {maximum: 15, option_name: 'deve ter no máximo 15 caracteres'}
  validates :value, numericality: {only_integer: true}
  validates :value, numericality: {greater_than_or_equal_to: 100, message: 'Preço mínimo de R$ 1,00'}
  before_validation :option_name_must_be_uniq_for_same_item, if: -> {item.present?}
  before_destroy :prevent_destroy
  after_create :register_changes_in_historic_create
  after_update :register_changes_in_historic_upload


  def menu_option_name
    "#{option_name} - #{formated_value}"
  end

  def formated_value
    price = attribute_in_database(:value).to_s.insert(-3, ',')
    "R$ #{price}"
  end

  def item_name
    persisted_name = attribute_in_database(:option_name)
    "#{item.name} - porção #{persisted_name}"
  end

  def created_date_portion
    "Porção cadastrada em #{I18n.l(created_at, format: "%d/%m/%y")}"
  end

  private

  def prevent_destroy
    self.errors[:base] << 'Não é permitido a exclusão de porções de um item'
    throw :abort
  end

  def option_name_must_be_uniq_for_same_item
    if item.portions.any? { |portion| portion.option_name == option_name && portion != self }
      errors.add(:option_name, 'deve ser única para o mesmo produto')
    end
  end

  def register_changes_in_historic_create
    register_changes_in_historic.created!
  end

  def register_changes_in_historic_upload
    if saved_change_to_option_name? || saved_change_to_value?
      register_changes_in_historic.updated!
    end
  end

  def register_changes_in_historic
    historics.create(
      item: item,
      description_portion: option_name,
      price_portion: formated_value,
      upload_date: Date.current
    )
  end
end
