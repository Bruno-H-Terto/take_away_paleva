class CreateCharacteristics < ActiveRecord::Migration[7.2]
  def change
    create_table :characteristics do |t|
      t.string :quality_name, null: false

      t.timestamps
    end
    add_index :characteristics, :quality_name, unique: true
  end
end
