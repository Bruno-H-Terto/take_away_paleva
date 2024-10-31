class MenusController < ApplicationController
  def index
    @take_away_stores = TakeAwayStore.find(params[:take_away_store_id])
  end
end