class RemoveIndexColumnToMenu < ActiveRecord::Migration[7.2]
  def change
    remove_index :menus, name: :index_menus_on_name
  end
end
