class AddTimeToHistoricalOrder < ActiveRecord::Migration[7.2]
  def change
    add_column :historical_orders, :time, :string
  end
end
