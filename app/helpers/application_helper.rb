module ApplicationHelper
  def take_away_store_item_path(store, item)
    send("take_away_store_#{item.class.name.downcase}_path",store, item)
  end
end
