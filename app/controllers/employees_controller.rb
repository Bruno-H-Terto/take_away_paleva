class EmployeesController < ApplicationController
  def index
    @take_away_store = current_store
    @profiles = @take_away_store.profiles
  end

  def new
    @take_away_store = current_store
    @profile = @take_away_store.profiles.build
  end

  def create
    @take_away_store = current_store
    @profile = @take_away_store.profiles.build(employee_profile_params)

    if @profile.save
      return redirect_to take_away_store_employees_path(@take_away_store), notice: 'Novo Funcionário registrado com sucesso!'
    end

    flash[:alert] = 'Não foi possível registrar seu Funcionário'
    render :new
  end

  private

  def employee_profile_params
    params.require(:profile).permit(:register_number, :email)
  end
end