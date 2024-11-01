class PortionsController < ApplicationController
  include ApplicationHelper
  before_action :authenticate_owner!
  before_action :set_take_away_store, only: %i[create]
  before_action :set_item, only: %i[create]
  before_action :set_portion, only: %i[update show]

  def create
    @portion = @item.portions.build(portion_params)

    if @portion.save
      return redirect_to take_away_store_item_path(@take_away_store, @item), notice: 'Porção adicionada com sucesso!'
    end

    controller_name = @item.class.name.underscore.pluralize
    flash.now[:alert] = 'Não foi possível adicionar sua porção'
    render "#{controller_name}/show", status: :unprocessable_entity
  end

  def show; end

  def update
    if @portion.update(portion_params)
      return redirect_to @portion, notice: 'Porção atualizada com sucesso!'
    end

    flash.now[:alert] = 'Não foi possível atualizar sua porção'
    render :show, status: :unprocessable_entity
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

  def portion_params
    params.require(:portion).permit(:option_name, :description, :value)
  end

  def set_portion
    @portion = Portion.find(params[:id])
    @owner = @portion.item.take_away_store.owner
    redirect_to root_path, alert: 'Acesso não autorizado' if current_owner != @owner
  end
end