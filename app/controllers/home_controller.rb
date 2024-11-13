class HomeController < ApplicationController
  def index
    if (owner_signed_in? || employee_signed_in?) && current_store.id.present?
      @employee = current_employee if employee_signed_in?
      @take_away_store = current_store
      @owner = @take_away_store.owner
      @menus = @owner.menus
      @items = @take_away_store.items.select { |item| item.active? }
      @menu = @owner.menus.build
      @order_items = []
      sum = 0
      @price = 0
      if session[:cart_items].present?
        begin
          session[:cart_items].group_by do |order_item|
            menu = @take_away_store.menus.find_by(id: order_item['menu'])
            item = @take_away_store.items.find_by(id: order_item['item'])
            portion = Portion.find_by(id: order_item['portion_id'])
            sum += portion.value*order_item['quantity'].to_i
  
            @order_items << {
              menu: menu,
              item: item,
              portion: portion.menu_option_name,
              observation: order_item['observation'],
              quantity: order_item['quantity']
            }
          end
          @price = "R$ #{sum.to_s.insert(-3, ',')}"
        rescue
          session.delete(:cart_items)
        end
      else
        session.delete(:cart_items)
      end
    end
  end

  def create_account; end

  def owner
    @owner = current_owner
  end
end