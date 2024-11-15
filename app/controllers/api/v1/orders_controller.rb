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