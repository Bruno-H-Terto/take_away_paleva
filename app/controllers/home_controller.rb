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
        @cart_items.each do |order_item|
          menu = current_store.menus.exists?(id: order_item['menu'])
          item = current_store.items.find_by(id: order_item['item'])
          portion = Portion.find_by(id: order_item['portion_id'])

          unless menu.present? && item.present? && portion.present?
            session.delete(:cart_items)
          end
        end
      end
    end
  end

  def create_account; end

  def owner
    @owner = current_owner
  end
end