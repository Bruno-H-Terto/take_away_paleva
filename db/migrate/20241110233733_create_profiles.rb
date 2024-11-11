class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
      t.string :register_number, null: false
      t.string :email, null: false
      t.references :take_away_store, null: false, foreign_key: true

      t.timestamps
    end
    add_index :profiles, :register_number, unique: true
    add_index :profiles, :email, unique: true
  end
end
