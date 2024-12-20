class Api::V1::ApiController < ActionController::API
  rescue_from ActiveRecord::ActiveRecordError, with: :return_500
  rescue_from ActiveRecord::RecordNotFound, with: :return_404

  private

  def return_500
    render status: 500, json: { error_message: 'Ocorreu um erro interno' }
  end

  def return_404
    render status: 404, json: { error_message: 'Recurso não localizado' }
  end

  def default_sanitizer_response(object)
    object.as_json(
      except: [:created_at, :updated_at]
      )
  end
end