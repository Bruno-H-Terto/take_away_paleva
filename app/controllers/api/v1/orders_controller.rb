class Api::V1::OrdersController < Api::V1::ApplicationController
  before_action :set_take_away_store
  def index
    orders = sanitizer_response(@store.orders)

    render status: 200, json: orders
  end

  def status
    orders = sanitizer_response(@store.orders.where(status: params[:status]))

    if orders.empty?
      orders = sanitizer_response(@store.orders)
    end

    render status: 200, json: orders
  end

  def show
    order = @store.orders.find_by!(code: params[:code])
    response_order_items = order.order_items.map do |order_item|
      {
        menu: order_item.menu.name,
        item: order_item.item.name,
        portion: order_item.portion.menu_option_name,
        observation: order_item.observation.presence || 'Nenhuma',
        quantity: order_item.quantity
      }
    end
  
    order_json = default_sanitizer_response(order)
    order_json['created_at_current'] = I18n.l(order.created_at_current, format: "%d/%m/%y - %H:%M")
  
    response = { order: order_json, order_items: response_order_items }
  
    render status: 200, json: response
  end

  private

  def set_take_away_store
    @store = TakeAwayStore.find_by(code: params[:store_code])
    raise ActiveRecord::RecordNotFound if @store.nil?
  end

  def sanitizer_response(object)
    object.as_json(
      except: [:created_at, :updated_at, :phone_number, :register_number, :email]
      )
  end
end