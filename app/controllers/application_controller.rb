class ApplicationController < ActionController::Base
  # Permitir apenas navegadores modernos com suporte a webp, web push, badges, import maps, CSS nesting e CSS :has.
  allow_browser versions: :modern

  before_action :set_owner, if: -> { owner_signed_in? }
  before_action :take_away_store_register, if: -> { owner_signed_in? }
  before_action :business_hours_register, if: -> { owner_signed_in? }
  before_action :owner_active, if: -> { owner_signed_in? }

  private

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
      current_employee&.take_away_store
    end
  end

  def authenticate_associated!
    return root_path unless owner_signed_in? || employee_signed_in?
  end
end
