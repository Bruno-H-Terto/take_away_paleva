class OrdersController < ApplicationController

  def index
    @orders = current_store.orders
  end

  def show
    @order = current_store.orders.find(params[:id])
    sum = 0
    @price = 0

    @order.order_items.each do |item|
      sum += item.portion.value * item.quantity.to_i
    end
    
    @price = "R$ #{sum.to_s.insert(-3, ',')}"
  end

  def new
    @order = current_store.orders.build
  end

  def create
    @order = current_store.orders.build(order_params)
    @order_items = []

    session[:cart_items].each do |order_item|
      menu = current_store.menus.find_by(id: order_item['menu'])
      item = current_store.items.find_by(id: order_item['item'])
      portion = Portion.find_by(id: order_item['portion_id'])

      if menu.present? && item.present? && portion.present?
        @order_items << @order.order_items.build(
          menu: menu,
          item: item,
          portion: portion,
          quantity: order_item['quantity'],
          observation: order_item['observation']
        )
      end
    end

    if @order.save && @order_items.all? { |item| item.save }
      session.delete(:cart_items)
      return redirect_to orders_path, notice: 'Pedido registrado com sucesso!'
    end

    flash[:alert] = 'Não foi possível concluir seu pedido'
    render :new
  end

  private

  def order_params
    params.require(:order).permit(:name, :register_number, :phone_number, :email)
  end
end