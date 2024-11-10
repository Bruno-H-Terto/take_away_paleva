class AddTimeCurrentToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :created_at_current, :datetime
  end
end
