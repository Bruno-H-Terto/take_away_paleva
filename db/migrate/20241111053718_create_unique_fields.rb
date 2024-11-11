class CreateUniqueFields < ActiveRecord::Migration[7.2]
  def change
    create_table :unique_fields do |t|
      t.string :email
      t.string :register_number

      t.timestamps
    end
    add_index :unique_fields, :register_number, unique: true
    add_index :unique_fields, :email, unique: true
  end
end
