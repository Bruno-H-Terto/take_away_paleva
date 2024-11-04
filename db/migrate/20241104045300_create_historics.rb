class CreateHistorics < ActiveRecord::Migration[7.2]
  def change
    create_table :historics do |t|
      t.references :item, null: false, foreign_key: true
      t.references :portion, null: false, foreign_key: true
      t.string :description_portion
      t.string :price_portion
      t.date :upload_date
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
