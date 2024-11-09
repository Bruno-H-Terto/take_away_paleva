class OrderItemsController < ApplicationController
  def cart
    @take_away_store = current_store
    session[:cart_items] ||= []

    session[:cart_items] << params[:item_id]
    redirect_to root_path, notice: 'Item adicionado ao carrinho'
  end
end