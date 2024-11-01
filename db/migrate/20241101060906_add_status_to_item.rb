class AddStatusToItem < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :status, :integer, null: false, default: 0
  end
end
