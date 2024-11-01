class ItemsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_owner!
  before_action :set_take_away_store_item, only: %i[change_status]
  before_action :set_take_away_store
  def index
    @dishes = @take_away_store.items.where(type: 'Dish')
    @beverages = @take_away_store.items.where(type: 'Beverage')
  end

  def change_status
    if @item.active?
      @item.inactive!
    else
      @item.active!
    end

    redirect_to take_away_store_item_path(@take_away_store, @item), notice: 'Status atualizado com sucesso!'
  end

  private

  def set_take_away_store
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])

    if @take_away_store.owner != current_owner
      return redirect_to take_away_store_path(current_owner.take_away_store), alert: 'Acesso não autorizado'
    end
  end

  def set_take_away_store_item
    @item = Item.find(params[:id])
  end
end