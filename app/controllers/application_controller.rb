class ApplicationController < ActionController::Base
  # Permitir apenas navegadores modernos com suporte a webp, web push, badges, import maps, CSS nesting e CSS :has.
  allow_browser versions: :modern
  before_action :set_owner, if: -> { owner_signed_in? }
  before_action :take_away_store_register, if: -> { owner_signed_in? }
  before_action :business_hours_register, if: -> { owner_signed_in? }
  before_action :owner_active, if: -> { owner_signed_in? }
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def money_value(money)
    money = money.to_s.insert(-3, ',')
    money = money.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
    "R$ #{money}"
  end

  private
  
  def prevent_double_access!
    active_user = owner_signed_in? || employee_signed_in?
    if active_user
      redirect_to root_path, alert: 'Login já realizado'
    end
  end

  def employee_unauthorized!
    return redirect_to root_path, alert: 'Acesso não autorizado' if employee_signed_in?
  end

  def set_owner
    @owner = current_owner
  end

  def take_away_store_register
    return if valid_path?([new_take_away_store_path, destroy_owner_session_path])
    
    if @owner.take_away_store.nil?
      redirect_to new_take_away_store_path, notice: 'Conclua seu cadastro.'
    end
  end

  def business_hours_register
    return if @owner.take_away_store.nil? || valid_path?([new_take_away_store_business_hour_path(@owner.take_away_store), destroy_owner_session_path])

    if @owner.take_away_store.business_hours.empty?
      redirect_to new_take_away_store_business_hour_path(@owner.take_away_store), notice: 'Para prosseguir, registre seu horário de funcionamento.'
    end
  end

  def owner_active; end

  def valid_path?(excluded_paths)
    excluded_paths.include?(request.path)
  end

  def current_store
    if owner_signed_in?
      current_owner&.take_away_store
    elsif employee_signed_in?
      current_employee.take_away_store
    else
      return redirect_to root_path, notice: 'Para prosseguir, faça login'
    end
  end

  def authenticate_associated!
    return root_path, notice: 'Para prosseguir, faça login' unless owner_signed_in? || employee_signed_in?
  end

  def record_not_found
    redirect_to root_path, notice: 'Requisição inválida'
  end

  def load_cart_session
    return [[], 0] unless session[:cart_items].present?

    order_items = []
    total_price = 0

    begin
      session[:cart_items].each do |order_item|
        menu, item, portion = find_cart_entities(order_item)

        if menu && item && portion
          order_items << build_cart_item(menu, item, portion, order_item)
          total_price += portion.value * order_item['quantity'].to_i
        end
      end
      [order_items, money_value(total_price)]
    rescue StandardError
      session.delete(:cart_items)
      [[], 0]
    end
  end

  def clear_cart_session
    session.delete(:cart_items)
  end

  def find_cart_entities(order_item)
    menu = current_store.menus.find_by(id: order_item['menu'])
    item = current_store.items.find_by(id: order_item['item'])
    portion = Portion.find_by(id: order_item['portion_id'])
    [menu, item, portion]
  end

  def build_cart_item(menu, item, portion, order_item)
    {
      menu: menu,
      item: item,
      portion: portion.menu_option_name,
      observation: order_item['observation'],
      quantity: order_item['quantity']
    }
  end
end
