class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :code
      t.string :name
      t.string :phone_number
      t.string :register_number
      t.string :email
      t.integer :status, null: false, default: 0
      t.references :take_away_store, null: false, foreign_key: true

      t.timestamps
    end
  end
end
