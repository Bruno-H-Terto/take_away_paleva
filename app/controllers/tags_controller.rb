class TagsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_owner!
  before_action :set_take_away_store, only: %i[new create]
  before_action :set_item, only: %i[new create]

  def new
    @tag = @item.tags.build
    @characteristic = @tag.build_characteristic
  end

  def create
    if tag_params[:characteristic_id].present?
      @characteristic = Characteristic.find(tag_params[:characteristic_id])
      @tag = @item.tags.build(characteristic: @characteristic)
    else
      @characteristic = Characteristic.find_or_create_by(quality_name: tag_params[:quality_name])
      @tag = @item.tags.build(characteristic: @characteristic)
    end
  
    if @tag.save
      return redirect_to take_away_store_item_path(@take_away_store, @item), notice: 'Marcador adicionado com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível adicionar seu marcador'
    render :new, status: :unprocessable_entity
  end
  

  private

  def set_take_away_store
    @take_away_store = TakeAwayStore.find(params[:take_away_store_id])
    if current_owner != @take_away_store.owner
      return redirect_to take_away_store_path(current_owner.take_away_store), alert: 'Acesso não autorizado'
    end
  end

  def set_item
    @item = Item.find(params[:item_id])
  end

  def tag_params
    params.require(:characteristic).permit(
      :quality_name, :characteristic_id)
  end
end