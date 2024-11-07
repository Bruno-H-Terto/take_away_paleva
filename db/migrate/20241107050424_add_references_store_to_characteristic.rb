class AddReferencesStoreToCharacteristic < ActiveRecord::Migration[7.2]
  def change
    add_reference :characteristics, :take_away_store, null: false, foreign_key: true
  end
end
