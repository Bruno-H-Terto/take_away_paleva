class OrdersController < ApplicationController
  before_action :authenticate_associated!
  before_action :set_take_away_store
  
  def index
    @orders = current_store.orders
  end

  def show
    @order = current_store&.orders.find(params[:id])

    @price = money_value(@order.total)
  end

  def new
    @order = current_store.orders.build
  end

  def create
    @order = current_store.orders.build(order_params)
    @order_items = []

    if session[:cart_items]
      session[:cart_items].each do |order_item|
        order_item = order_item.transform_keys(&:to_sym)

        menu = current_store.menus.find_by(id: order_item[:menu])
        item = current_store.items.find_by(id: order_item[:item])
        portion = Portion.find_by(id: order_item[:portion_id])

        if menu.present? && item.present? && portion.present?
          @order_items << @order.order_items.build(
            menu: menu,
            item: item,
            portion: portion,
            quantity: order_item[:quantity],
            observation: order_item[:observation]
          )
        end
      end
    else
      return redirect_to root_path, alert: 'Adicione itens ao carrinho para confirmar um pedido!'
    end

    if @order.valid? && @order_items.present? && @order_items.all?(&:valid?)
      @order.save
      @order_items.each { |item| item.save }
      session.delete(:cart_items)
      return redirect_to orders_path, notice: 'Pedido registrado com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível concluir seu pedido'
    render :new, status: :unprocessable_entity
  end

  private

  def order_params
    params.require(:order).permit(:name, :register_number, :phone_number, :email)
  end

  def set_take_away_store
    @take_away_store = current_store
  end
end