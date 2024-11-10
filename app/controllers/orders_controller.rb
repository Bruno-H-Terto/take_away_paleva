class OrdersController < ApplicationController

  def index
    @orders = current_store.orders
  end

  def new
    @order = current_store.orders.build
  end

  def create
    @order = current_store.orders.build(order_params)

    if @order.save
      session.delete(:cart_items)
      return redirect_to orders_path, notice: 'Pedido registrado com sucesso!'
    end
  end

  private

  def order_params
    params.require(:order).permit(:name, :register_number, :phone_number, :email)
  end
end