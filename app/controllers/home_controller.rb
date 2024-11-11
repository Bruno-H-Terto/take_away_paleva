class HomeController < ApplicationController
  def index
    if (owner_signed_in? || employee_signed_in?) && current_store.id.present?
      @employee = current_employee if employee_signed_in?
      @take_away_store = current_store
      @owner = @take_away_store.owner
      @menus = @owner.menus
      @items = @take_away_store.items.select { |item| item.active? }
      @menu = @owner.menus.build
      if session[:cart_items]
        @cart_items = session[:cart_items]
      end
    end
  end

  def create_account; end

  def owner
    @owner = current_owner
  end
end