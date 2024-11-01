class CreatePortions < ActiveRecord::Migration[7.2]
  def change
    create_table :portions do |t|
      t.string :option_name, null: false
      t.string :description, limit: 15
      t.integer :value, null: false
      t.references :item, null: false, foreign_key: true

      t.timestamps
    end
  end
end
