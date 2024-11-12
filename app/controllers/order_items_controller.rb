class OrderItemsController < ApplicationController
  def cart
    if params[:menu_id].empty? || params[:item_id].empty? || params[:portion_id].empty? || params[:quantity].empty?
      return redirect_to root_path, alert: 'Não foi possível adicionar seu item ao carrinho'
    end

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
      begin
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
      rescue
        session.delete(:cart_items)
      end
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

  def edit
    return redirect_to root_path, notice: 'Sem itens presentes no carrinho' if session[:cart_items].empty?

    @item = ''
    @take_away_store = current_store
    order_item = session[:cart_items][params[:id].to_i]
    menu = @take_away_store.menus.find_by(id: order_item['menu'])
    item = @take_away_store.items.find_by(id: order_item['item'])
    portion = Portion.find_by(id: order_item['portion_id'])

    @item = {
      menu: menu,
      item: item,
      portion: portion,
      observation: order_item['observation'],
      quantity: order_item['quantity']
    }
  end

  def update
    return redirect_to root_path, notice: 'Sem itens presentes no carrinho' if session[:cart_items].empty?

    order_item_params = params[:order_item]
    menu_id = params[:menu]
    item_id = params[:item]
    portion_id = params[:portion]

    if order_item_params[:quantity].empty? || menu_id.empty? || item_id.empty? || portion_id.empty?
      return redirect_to order_items_path, alert: 'Não foi possível atualizar seu item'
    end
    
    session[:cart_items][params[:id].to_i] = {
      menu: menu_id,
      item: item_id,
      portion_id: portion_id,
      observation: order_item_params[:observation],
      quantity: order_item_params[:quantity]
    }
  
    redirect_to order_items_path, notice: 'Item atualizado ao carrinho'
  end
end
