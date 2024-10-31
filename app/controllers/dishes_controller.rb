class DishesController < ApplicationController
  def show
    @dish = Dish.find(params[:id])
  end

  def new
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    @dish = @take_away_store.menus.build
  end

  def create
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    @dish = @take_away_store.menus.build(dish_params)

    if @dish.save
      return redirect_to take_away_store_dish_path(@take_away_store, @dish), notice: 'Prato adicionado com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível cadastrar seu prato'
    render :new, status: :unprocessable_entity
  end

  private

  def dish_params
    params.require(:menu).permit(:name, :description, :calories, :type)
  end
end