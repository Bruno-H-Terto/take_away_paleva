class Order < ApplicationRecord
  belongs_to :take_away_store
  has_many :order_items
  has_many :registers
  has_many :historical_orders, through: :registers
  has_one :reason_cancel
  validates :name, presence: true
  before_create :generate_code
  before_create :created_time_current
  after_create :historical_order_create
  after_update :historical_order
  before_validation :phone_or_email_must_be_present
  validates_with RegisterValidator, field: :register_number, length: 11, if: -> { register_number.present? }
  validates_with PhoneValidator, field: :phone_number, if: -> { phone_number.present? }
  validates :email, format: { 
    with: /\A[a-z0-9]+([\.\-_][a-z0-9]+)*@[a-z0-9]+(-[a-z0-9]+)*(\.[a-z]{2,})+\z/i,
    message: 'deve ser em um formato válido'
  }, if: -> { email.present? }

  enum :status, {
    waiting_confirmation: 0,
    preparing: 5,
    canceled: 10,
    done: 15,
    finished: 20
  }
  
  def contact
    "#{phone_number.presence || 'Sem telefone'} - #{email.presence || 'Sem e-mail' }"
  end

  def formated_value
    money_value(self.total)
  end

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def created_time_current
    self.created_at_current = created_at
  end

  def phone_or_email_must_be_present
    if phone_number.empty? && email.empty?
      errors.add(:base, 'Telefone ou email deve ser passado')
    end
  end

  def historical_order
    return unless saved_change_to_status?

    historical_orders.create!(
      information: I18n.t(status),
      time: formated_time
    )
  end

  def historical_order_create
    historical_orders.create!(
      information: I18n.t(status),
      time: formated_time
    )
  end

  def formated_time
    Time.now.strftime("%d/%m/%Y - %H:%M")
  end
end
