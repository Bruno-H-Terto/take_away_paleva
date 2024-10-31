class BeveragesController < ApplicationController
  def show
    @beverage = Beverage.find(params[:id])
  end

  def new
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    @beverage = @take_away_store.menus.build
  end

  def create
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    @beverage = @take_away_store.menus.build(beverages_params)

    if @beverage.save
      return redirect_to take_away_store_beverage_path(@take_away_store, @beverage), notice: 'Bebida adicionada com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível cadastrar sua bebida'
    render :new, status: :unprocessable_entity
  end

  private

  def beverages_params
    params.require(:menu).permit(:name, :description, :calories, :type, photos: [])
  end
end