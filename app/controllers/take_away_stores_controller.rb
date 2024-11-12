class TakeAwayStoresController < ApplicationController
  before_action :authenticate_associated!, only: %i[show]
  before_action :employee_unauthorized!, except: %i[show]
  before_action :authenticate_owner!, except: %i[show]
  before_action :take_away_store_register, except: %i[create], if: -> {owner_signed_in?}
  before_action :set_take_away_store, only: %i[show edit update]

  def search
    @take_away_store = TakeAwayStore.find_by(owner: current_owner)
    @query = params[:query]
    if @query.blank?
      return @results = 'Valor de busca inválido'
    end
    
    @results = @take_away_store.search_query(@query)
  end

  def new
    @take_away_store = @owner.build_take_away_store
  end

  def create
    @take_away_store = @owner.build_take_away_store(take_away_store_params)

    if @take_away_store.save
      return redirect_to new_take_away_store_business_hour_path(@take_away_store), notice: t('take_away_store.create_register', name: @take_away_store.trade_name)
    end

    flash.now[:alert] = t('take_away_store.failure_create')
    render :new, status: :unprocessable_entity
  end

  def show; end

  def edit; end

  def update
    if @take_away_store.update(take_away_store_params)
      return redirect_to @take_away_store, notice: t('take_away_store.update_register', name: @take_away_store.trade_name)
    end

    flash.now[:alert] = t('take_away_store.failure_update')
    render :edit, status: :unprocessable_entity
  end
  private

  def take_away_store_params
    params.require(:take_away_store).permit(:trade_name, :corporate_name,
    :register_number, :phone_number, :street, :number, :district, :city,
    :state, :zip_code, :complement, :email)
  end

  def set_take_away_store
    @take_away_store = current_store
    if current_store != TakeAwayStore.find(params[:id])
      return redirect_to TakeAwayStore.find_by(owner: @owner), alert: 'Acesso negado - Não é permito visualizar dados de outro Estabelecimento'
    end
  end
end