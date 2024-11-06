class MenusController < ApplicationController
  def create
    @owner = current_owner
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    @menu = @take_away_store.menus.build(menu_params)

    if @menu.save
      return redirect_to take_away_store_menu_path(@take_away_store, @menu), notice: "Cardápio #{@menu.name} cadastrado com sucesso!"
    end

    flash.now[:alert] = 'Não foi possível cadastrar o seu cardápio'
    render 'home/index', status: :unprocessable_entity
  end

  def show
    @menu = Menu.find(params[:id])
    @take_away_store = @menu.take_away_store
    @menu_items = @menu.item_menus.build
  end

  private

  def menu_params
    params.require(:menu).permit(:name)
  end
end