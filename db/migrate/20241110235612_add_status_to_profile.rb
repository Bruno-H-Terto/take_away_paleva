class AddStatusToProfile < ActiveRecord::Migration[7.2]
  def change
    add_column :profiles, :status, :integer, null: false, default: 0
  end
end
