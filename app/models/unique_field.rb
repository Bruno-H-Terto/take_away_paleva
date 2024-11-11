class UniqueField < ApplicationRecord
  belongs_to :registrable, polymorphic: true
end
