class DishesController < ApplicationController
  before_action :set_take_away_store_dish
  def show
    @dish = Dish.find(params[:id])
  end

  def new
    @dish = @take_away_store.items.build(type: 'Dish')
  end

  def create
    @dish = @take_away_store.items.build(dish_params)

    if @dish.save
      return redirect_to take_away_store_dish_path(@take_away_store, @dish), notice: 'Prato adicionado com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível cadastrar seu prato'
    render :new, status: :unprocessable_entity
  end

  def edit
    @dish = Dish.find(params[:id])
  end

  def update
    @dish = Dish.find(params[:id])

    if @dish.update(dish_params)
      return redirect_to take_away_store_dish_path(@take_away_store, @dish), notice: 'Prato atualizado com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível atualizar seu prato'
    render :edit, status: :unprocessable_entity
  end

  private

  def dish_params
    params.require(:dish).permit(:name, :description, :calories, :type, :photo )
  end
  
  def set_take_away_store_dish
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    if current_owner != @take_away_store.owner
      return redirect_to take_away_store_path(current_owner.take_away_store), alert: 'Acesso não autorizado'
    end
  end
end