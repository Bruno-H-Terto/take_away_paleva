class CreateReasonCancels < ActiveRecord::Migration[7.2]
  def change
    create_table :reason_cancels do |t|
      t.references :order, null: false, foreign_key: true
      t.text :information
      t.text :time
      
      t.timestamps
    end
  end
end
