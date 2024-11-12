class BeveragesController < ApplicationController
  before_action :employee_unauthorized!
  before_action :authenticate_owner!
  before_action :set_take_away_store_beverage
  before_action :set_beverage, only: %i[show edit update destroy]

  def show
    @item = @beverage
    @portion = @item.portions.build
    @tag = @item.tags.build
    @characteristic = @item.characteristics.build
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

  def edit; end

  def update
    if @beverage.update(beverage_params)
      return redirect_to take_away_store_beverage_path(@take_away_store, @beverage), notice: 'Bebida atualizada com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível atualizar sua bebida'
    render :edit, status: :unprocessable_entity
  end

  def destroy
    if @beverage.destroy
      return redirect_to take_away_store_path(@take_away_store), notice: 'Bebida excluída com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível excluir a bebida selecionada'
    render :show, status: :unprocessable_entity
  end

  private

  def beverage_params
    params.require(:beverage).permit(:name, :description, :calories, :type, :photo )
  end

  def set_beverage
    @beverage = Beverage.find(params[:id])
  end
  
  def set_take_away_store_beverage
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    if current_owner != @take_away_store.owner
      return redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end
end