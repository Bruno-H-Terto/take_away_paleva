class Api::V1::StoresController < Api::V1::ApiController
  def index
    stores = TakeAwayStore.all
    if stores.present?
      response = stores.as_json(
        except: [:created_at, :updated_at, :register_number, :district, :city,
                :state, :zip_code, :complement, :street, :id, :owner_id, :number,
                :phone_number
              ]
        )
    else
      response = 'Não foram localizados Estabelecimento registrados'
    end

    render status: 200, json: {stores: response}
  end


  def show
    store = TakeAwayStore.find_by!(code: params[:code])
    store_response = default_sanitizer_response(store)

    render status: 200, json: { store: store_response }
  end
end