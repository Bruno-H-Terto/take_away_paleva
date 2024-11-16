class Api::V1::StoresController < Api::V1::ApiController
  def show
    store = TakeAwayStore.find_by!(code: params[:code])
    store_response = default_sanitizer_response(store)

    render status: 200, json: { store: store_response }
  end
end