class AddTotalToOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :total, :integer, default: 0
  end
end
