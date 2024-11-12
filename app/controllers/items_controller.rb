class ItemsController < ApplicationController
  include ApplicationHelper
  before_action :employee_unauthorized!
  before_action :authenticate_owner!
  before_action :set_take_away_store_item, only: %i[change_status historical]
  before_action :set_take_away_store

  def index
    if params[:select_tag].present?
      tag = Characteristic.find(params[:select_tag])
      items = tag.items

      if items&.any?
        @dishes = items.where(type: 'Dish')
        @beverages = items.where(type: 'Beverage')
      else
        flash[:notice] = "Sem resultados para #{tag.quality_name}"
      end
    else
      @dishes = @take_away_store.items.where(type: 'Dish')
      @beverages = @take_away_store.items.where(type: 'Beverage')
    end
    @tags = Characteristic.all.order(quality_name: :asc)
  end

  def change_status
    if @item.active?
      @item.inactive!
    else
      @item.active!
    end

    redirect_to take_away_store_item_path(@take_away_store, @item), notice: 'Status atualizado com sucesso!'
  end

  def historical
    historical = @item.historics
    @registers = historical.group_by { |register| register.portion }
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