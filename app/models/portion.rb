class Portion < ApplicationRecord
  belongs_to :item, dependent: :destroy
end
