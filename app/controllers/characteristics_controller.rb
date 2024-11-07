class CharacteristicsController < ApplicationController
  def index
    @take_away_store = @owner.take_away_store
    @characteristics = @take_away_store.characteristics.select(&:persisted?)
    @characteristic = @take_away_store.characteristics.build
  end

  def create
    @take_away_store = @owner.take_away_store
    @characteristic = @take_away_store.characteristics.build(characteristic_params)

    if @characteristic.save
      return redirect_to characteristics_path, notice: "Marcador #{@characteristic.quality_name} criado com sucesso!"
    end

    flash.now[:alert] = 'Não foi possível criar seu marcador'
    @characteristics = @take_away_store.characteristics
    render :index, status: :unprocessable_entity
  end

  private

  def characteristic_params
    params.require(:characteristic).permit(:quality_name)
  end
end