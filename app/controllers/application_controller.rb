class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :take_away_store_register, if: -> { owner_signed_in? }

  def take_away_store_register
    valid_path = (request.path != new_take_away_store_path) && (request.path != destroy_owner_session_path)
    if valid_path && current_owner.take_away_store.nil?
      return redirect_to new_take_away_store_path, alert: 'Conclua seu cadastro.'
    end
  end
end
