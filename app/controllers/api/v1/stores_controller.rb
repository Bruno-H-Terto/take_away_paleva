class Api::V1::StoresController < Api::V1::ApiController
  def show
    store = TakeAwayStore.find_by!(code: params[:code])
    store_response = store.as_json(except: [:created_at, :updated_at])

    render status: 200, json: { store: store_response }
  end
end