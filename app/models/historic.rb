class Historic < ApplicationRecord
  belongs_to :item
  belongs_to :portion
  validates :description_portion, :price_portion, :upload_date, presence: true

  enum :status, {created: 0, updated: 5}

  def historical_list
    msg = ""
    if created?
      msg << 'Adicionado: '
    else
      msg << 'Atualizado: '
    end
    msg << "#{I18n.l(self.upload_date, format: "%d/%m/%y")} - Porção #{self.description_portion} | #{self.price_portion}"
  end
  
end
