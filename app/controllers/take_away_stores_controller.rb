class TakeAwayStoresController < ApplicationController
  before_action :authenticate_owner!
  before_action :take_away_store_register, except: %i[create]
  before_action :set_take_away_store, only: %i[show]
  def new
    @take_away_store = current_owner.build_take_away_store
  end

  def create
    @take_away_store = current_owner.build_take_away_store(take_away_store_params)

    if @take_away_store.save
      return redirect_to @take_away_store, notice: t('take_away_store.create_register', name: @take_away_store.trade_name)
    end

    flash.now[:alert] = t('take_away_store.failure_create')
    render new:, status: :unprocessable_entity
  end

  def show
  end

  private

  def take_away_store_params
    params.require(:take_away_store).permit(:trade_name, :corporate_name,
    :register_number, :phone_number, :street, :number, :district, :city,
    :state, :zip_code, :complement, :email)
  end

  def set_take_away_store
    @take_away_store = TakeAwayStore.find(params[:id])
  end
end