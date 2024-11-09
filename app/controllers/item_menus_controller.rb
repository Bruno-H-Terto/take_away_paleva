class ItemMenusController < ApplicationController
  def create
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    @menu = @take_away_store.menus.find(params[:menu_id])
    @item = @take_away_store.items.find(item_menu_params[:item_id])
    @item_menu = @menu.item_menus.build(item: @item)

    if @item_menu.save
      redirect_to take_away_store_menu_path(@take_away_store, @menu), notice: 'Item adicionado com sucesso!'
    else
      flash.now[:alert] = 'Não foi possível adicionar seu item ao Menu'
      render 'menus/show', status: :unprocessable_entity
    end
  end

  private

  def item_menu_params
    params.require(:item_menu).permit(:item_id)
  end
end
