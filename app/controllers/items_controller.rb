class ItemsController < ApplicationController
  def index
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    @dishes = @take_away_store.items.where(type: 'Dish')
  end
end