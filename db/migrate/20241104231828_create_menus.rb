class CreateMenus < ActiveRecord::Migration[7.2]
  def change
    create_table :menus do |t|
      t.string :name, null: false
      t.references :take_away_store, null: false, foreign_key: true

      t.timestamps
    end

    add_index :menus, :name, unique: true
  end
end
