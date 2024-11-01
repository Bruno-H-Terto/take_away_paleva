class DishesController < ApplicationController
  before_action :authenticate_owner!
  before_action :set_take_away_store_dish
  before_action :set_dish, only: %i[show edit update destroy]

  def show; end

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

  def edit; end

  def update
    if @dish.update(dish_params)
      return redirect_to take_away_store_dish_path(@take_away_store, @dish), notice: 'Prato atualizado com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível atualizar seu prato'
    render :edit, status: :unprocessable_entity
  end

  def destroy
    if @dish.destroy
      return redirect_to take_away_store_path(@take_away_store), notice: 'Prato excluído com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível excluir o prato selecionado'
    render :show, status: :unprocessable_entity
  end

  private

  def dish_params
    params.require(:dish).permit(:name, :description, :calories, :type, :photo )
  end
  
  def set_dish
    @dish = Dish.find(params[:id])
  end
  
  def set_take_away_store_dish
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    if current_owner != @take_away_store.owner
      return redirect_to take_away_store_path(current_owner.take_away_store), alert: 'Acesso não autorizado'
    end
  end
end