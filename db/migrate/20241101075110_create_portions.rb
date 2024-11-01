class CreatePortions < ActiveRecord::Migration[7.2]
  def change
    create_table :portions do |t|
      t.string :option_name, limit: 16, null: false
      t.integer :value, null: false
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
