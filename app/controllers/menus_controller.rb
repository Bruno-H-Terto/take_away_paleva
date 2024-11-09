class MenusController < ApplicationController
  before_action :authenticate_owner!
  before_action :set_take_away_store
  
  def create
    @menus = @take_away_store&.menus
    @menu = @take_away_store.menus.build(menu_params)

    if @menu.save
      return redirect_to take_away_store_menu_path(@take_away_store, @menu), notice: "Cardápio #{@menu.name} cadastrado com sucesso!"
    end

    flash.now[:alert] = 'Não foi possível cadastrar o seu cardápio'
    render 'home/index', status: :unprocessable_entity
  end

  def show
    @menu = Menu.find(params[:id])
    @menu_items = @menu.item_menus.build
    @items = @take_away_store.items.select { |item| item.active? && item.portions.any? }
  end

  private

  def menu_params
    params.require(:menu).permit(:name)
  end

  def set_take_away_store
    @owner = current_owner
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    if @owner != @take_away_store.owner
      return redirect_to root_path, notice: 'Acesso não autorizado. Não é permitido o acesso a dados de terceiros'
    end
  end
end