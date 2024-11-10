class Order < ApplicationRecord
  belongs_to :take_away_store
  before_create :generate_code
  before_create :created_time_current



  private

  def generate_code
    self.code = SecureRandom.alphanumeric(8).upcase
  end

  def created_time_current
    Time.zone = 'Brasilia'
    self.created_at_current = Time.zone.now
  end
end
