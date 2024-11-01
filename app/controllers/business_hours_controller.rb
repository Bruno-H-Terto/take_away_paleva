class BusinessHoursController < ApplicationController
  before_action :authenticate_owner!
  before_action :set_take_away_store
  before_action :set_business_hour, only: %i[edit update]
  before_action :business_hours_register, except: %i[create]
  def new
    BusinessHour.day_of_weeks.each do |key, _|
      @take_away_store.business_hours.build(day_of_week: key)
    end
  end

  def create
    @business_hours = @take_away_store.business_hours.build(business_hours_params[:business_hours_attributes].values)
    @business_hours.each {|business_hour| business_hour.validate}

    if @business_hours.all?(&:valid?)
      if @business_hours.all? { |day| day.closed? }
        flash.now[:alert] = 'Selecione ao menos um dia de funcionamento'
        render :new, status: :unprocessable_entity
        return
      end

      @business_hours.each {|business_hour| business_hour.save}
      redirect_to take_away_store_path(@take_away_store), notice: 'Horário registrado com sucesso'
    else
      flash.now[:alert] = 'Não foi possível incluir seus horários, revise os campos abaixo:'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @business_hour.update(business_hour_params)
      return redirect_to take_away_store_path(@take_away_store), notice: 'Horário atualizado com sucesso'
    end

    flash.now[:alert] = 'Não foi possível atualizar seu horário, revise os campos abaixo:'
    render :edit, status: :unprocessable_entity
  end

  private

  def set_take_away_store
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id]) 
  end

  def set_business_hour
    @business_hour = BusinessHour.find(params[:id])
    @take_away_store = set_take_away_store
    if @take_away_store.owner != @owner
      return redirect_to TakeAwayStore.find_by(owner: @owner), alert: 'Acesso negado - Não é permito visualizar dados de outro Estabelecimento'
    end
  end

  def business_hours_params
    params.require(:take_away_store).permit(
      business_hours_attributes: [permited_params]
    )
  end

  def business_hour_params
    params.require(:business_hour).permit(
      permited_params.each {|param| param}
    )
  end

  def permited_params
    pemited = [:id, :open_time, :close_time, :status, :day_of_week]
  end
end