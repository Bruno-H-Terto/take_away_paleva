class CreateMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :menus do |t|
      t.string :name
      t.text :description
      t.integer :calories
      t.string :type
      t.references :take_away_store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
