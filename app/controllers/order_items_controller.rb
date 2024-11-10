class OrderItemsController < ApplicationController
  def cart
    @take_away_store = current_store
    session[:cart_items] ||= []

    session[:cart_items] << {
      menu: params[:menu_id],
      item: params[:item_id],
      portion_id: params[:portion_id],
      observation: params[:observation],
      quantity: params[:quantity]
    }
    
    redirect_to root_path, notice: 'Item adicionado ao carrinho'
  end

  def index
    @take_away_store = current_store
    @order_items = []
    sum = 0
    @price = 0

    if session[:cart_items].present?
      
      session[:cart_items].each do |order_item|
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
    else
      session.delete(:cart_items)
    end
  end

  def destroy
    if session[:cart_items]
      session[:cart_items].delete_at(params[:id].to_i)
    end

    session.delete(:cart_items) if session[:cart_items].empty?
  
    redirect_to order_items_path, notice: 'Item removido do carrinho'
  end
end
