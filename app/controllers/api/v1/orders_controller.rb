class Api::V1::OrdersController < Api::V1::ApplicationController
  def index
    store = TakeAwayStore.find(params[:store_id])
    orders = store.orders.as_json(
      except: [:created_at, :updated_at, :phone_number, :register_number, :email]
      )
    render status: 200, json: orders
  end
end