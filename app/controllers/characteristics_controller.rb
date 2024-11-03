class CharacteristicsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_owner!
  before_action :set_take_away_store, only: %i[create]
  before_action :set_item, only: %i[create]

  def create
    if params[:tag][:characteristic_id].present?
      characteristic = Characteristic.find(params[:tag][:characteristic_id])
    else
      characteristic = Characteristic.create(quality_name: tag_params[:quality_name])
    end
  
    @tag = @item.tags.build(characteristic: characteristic)
  
    if @tag.save
      redirect_to take_away_store_item_path(@take_away_store, @item), notice: 'Marcador adicionado com sucesso!'
    else
      flash.now[:alert] = 'Não foi possível adicionar seu marcador'
      render "#{controller_name}/show", status: :unprocessable_entity
    end
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
    params.require(:tag).permit(
      :quality_name)
  end
end