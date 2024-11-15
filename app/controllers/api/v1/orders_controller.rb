class Api::V1::OrdersController < Api::V1::ApplicationController
  def index
    store = TakeAwayStore.find_by(code: params[:store_code])
    raise ActiveRecord::RecordNotFound, 'Estabelecimento não localizado' if store.nil?

    orders = store.orders.as_json(
      except: [:created_at, :updated_at, :phone_number, :register_number, :email]
      )

    render status: 200, json: orders
  end
end