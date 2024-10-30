class CreateTakeAwayStores < ActiveRecord::Migration[7.2]
  def change
    create_table :take_away_stores do |t|
      t.string :trade_name, null: false
      t.string :corporate_name, null: false
      t.string :register_number, null: false
      t.string :street, null: false
      t.string :number, null: false
      t.string :district, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.string :complement
      t.string :phone_number, null: false
      t.string :email, null: false
      t.string :code, null: false
      t.references :owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
