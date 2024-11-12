class TagsController < ApplicationController
  include ApplicationHelper
  before_action :employee_unauthorized!
  before_action :authenticate_owner!
  before_action :set_take_away_store, only: %i[new create destroy]
  before_action :set_item, only: %i[new create destroy]
  before_action :set_tag, only: %i[destroy]

  def new
    @tag = @item.tags.build
    @characteristic = @tag.build_characteristic
  end

  def create
    if tag_params[:characteristic_id].present?
      @characteristic = @take_away_store.characteristics.find(tag_params[:characteristic_id])
      @tag = @item.tags.build(characteristic: @characteristic)
    else
      @characteristic = @take_away_store.characteristics.create(quality_name: tag_params[:quality_name])
      @tag = @item.tags.build(characteristic: @characteristic)
    end
  
    if @tag.save
      return redirect_to take_away_store_item_path(@take_away_store, @item), notice: 'Marcador adicionado com sucesso!'
    end

    flash[:alert] = 'Não foi possível adicionar seu marcador'
    if tag_params[:characteristic_id].blank? && params[:commit] == 'Adicionar Tag'
      return redirect_to take_away_store_item_path(@take_away_store, @item)
    end

    render :new, status: :unprocessable_entity
  end
  
  def destroy
    @tag = Tag.find_by(characteristic: @characteristic, item: @item)
    @tag.destroy

    return redirect_to take_away_store_item_path(@take_away_store, @item), notice: 'Tag removida com sucesso!'
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

  def set_tag
    @characteristic = Characteristic.find(params[:id])
  end
end