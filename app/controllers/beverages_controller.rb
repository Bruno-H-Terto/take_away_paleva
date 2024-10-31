class BeveragesController < ApplicationController
  before_action :set_take_away_store_beverage

  def show
    @beverage = Beverage.find(params[:id])
  end

  def new
    @beverage = @take_away_store.items.build(type: 'Beverage')
  end

  def create
    @beverage = @take_away_store.items.build(beverage_params)

    if @beverage.save
      return redirect_to take_away_store_beverage_path(@take_away_store, @beverage), notice: 'Bebida adicionada com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível cadastrar sua bebida'
    render :new, status: :unprocessable_entity
  end

  def edit
    @beverage = Beverage.find(params[:id])
  end

  def update
    @beverage = Beverage.find(params[:id])

    if @beverage.update(beverage_params)
      return redirect_to take_away_store_beverage_path(@take_away_store, @beverage), notice: 'Bebida atualizada com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível atualizar sua bebida'
    render :edit, status: :unprocessable_entity
  end

  private

  def beverage_params
    params.require(:beverage).permit(:name, :description, :calories, :type, :photo )
  end
  
  def set_take_away_store_beverage
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    if current_owner != @take_away_store.owner
      return redirect_to take_away_store_path(current_owner.take_away_store), alert: 'Acesso não autorizado'
    end
  end
end