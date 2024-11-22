class CreateRegisters < ActiveRecord::Migration[7.2]
  def change
    create_table :registers do |t|
      t.references :order, null: false, foreign_key: true
      t.references :historical_order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
