class HomeController < ApplicationController
  def index
    if owner_signed_in? && current_owner.take_away_store.id.present?
      @owner = current_owner
      @take_away_store = @owner.take_away_store
      @menus = @owner.menus
      @menu = @owner.menus.build
    end
  end

  def owner
    @owner = current_owner
  end
end