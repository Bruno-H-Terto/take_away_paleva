class CharacteristicsController < ApplicationController
  def index
    @take_away_store = @owner.take_away_store
    @characteristics = @take_away_store.characteristics
  end
end