class Api::V1::OrdersController < Api::V1::ApiController
  before_action :set_take_away_store
  def index
    orders = @store.orders.order(created_at_current: :asc)

    if orders.present?
      response = sanitizer_response(orders)
    else
      response = {message: 'Sem pedidos registrados'}
    end

    render status: 200, json: response
  end

  def status
    if Order.statuses.keys.include?(params[:status])
      orders = sanitizer_response(@store.orders.where(status: params[:status]).order(created_at_current: :asc))
      if orders.empty?
        orders = {message: 'Não foram localizados pedidos com este status'}
      end
    else
      
      orders = sanitizer_response(@store.orders.order(created_at_current: :asc))
    end

    render status: 200, json: orders
  end

  def show
    order = @store.orders.find_by!(code: params[:code])

    if order.order_items.empty?
      response_order_items = { message: 'Sem itens registrados' }
    else
      response_order_items = order.order_items.map do |order_item|
        {
          menu: order_item.menu.name,
          item: order_item.item.name,
          portion: order_item.portion.menu_option_name,
          observation: order_item.observation.presence || 'Nenhuma',
          quantity: order_item.quantity
        }
      end
    end
    order_json = default_sanitizer_response(order)
    order_json['created_at_current'] = I18n.l(order.created_at_current, format: "%d/%m/%y - %H:%M")
  
    response = { order: order_json, order_items: response_order_items }
  
    render status: 200, json: response
  end

  def confirmed
    order = @store.orders.find_by!(code: params[:code])

    if order.waiting_confirmation?
      if order.order_items.empty?
        response_order_items = { message: 'Não é permitido a confirmação de pedidos sem itens registrados' }
      else
        order.preparing!
        response_order_items = order.order_items.map do |order_item|
          {
            menu: order_item.menu.name,
            item: order_item.item.name,
            portion: order_item.portion.menu_option_name,
            observation: order_item.observation.presence || 'Nenhuma',
            quantity: order_item.quantity
          }
        end
      end
      order_json = default_sanitizer_response(order)
      order_json['created_at_current'] = I18n.l(order.created_at_current, format: "%d/%m/%y - %H:%M")
      response = { order: order_json, order_items: response_order_items }
    else
      response = { message: 'Status do pedido inválido para confirmação' }
    end

    render status: 200, json: response
  end

  def done
    order = @store.orders.find_by!(code: params[:code])

    if order.preparing?
      if order.order_items.empty?
        order.canceled!
        response_order_items = { message: 'Pedido cancelado, não é permitido a conclusão sem itens registrados' }
      else
        order.done!
        response_order_items = order.order_items.map do |order_item|
          {
            menu: order_item.menu.name,
            item: order_item.item.name,
            portion: order_item.portion.menu_option_name,
            observation: order_item.observation.presence || 'Nenhuma',
            quantity: order_item.quantity
          }
        end
      end
      order_json = default_sanitizer_response(order)
      order_json['created_at_current'] = I18n.l(order.created_at_current, format: "%d/%m/%y - %H:%M")
      response = { order: order_json, order_items: response_order_items }
    else
      response = { message: 'Status do pedido inválido para conclusão' }
    end

    render status: 200, json: response
  end

  def canceled
    order = @store.orders.find_by!(code: params[:code])

    if (order.waiting_confirmation? || order.preparing?)
      if params[:reason].present?
        order.create_reason_cancel!(information: params[:reason], time: params[:time])
        order.canceled!
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
      else
        response = { message: 'Deve apresentar a justificava para o cancelamento' }
      end
    else
      response = { message: 'Status do pedido inválido para o cancelamento' }
    end
    
    render status: 200, json: response
  end

  private

  def set_take_away_store
    @store = TakeAwayStore.find_by!(code: params[:store_code])
  end

  def sanitizer_response(object)
    object.as_json(
      except: [:created_at, :updated_at, :phone_number, :register_number, :email]
      )
  end
end