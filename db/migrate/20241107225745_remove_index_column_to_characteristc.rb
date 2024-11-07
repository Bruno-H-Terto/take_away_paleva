class RemoveIndexColumnToCharacteristc < ActiveRecord::Migration[7.2]
  def change
    remove_index :characteristics, name: :index_characteristics_on_quality_name
  end
end
