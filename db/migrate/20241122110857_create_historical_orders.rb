class CreateHistoricalOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :historical_orders do |t|
      t.text :information

      t.timestamps
    end
  end
end
