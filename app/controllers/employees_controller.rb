class EmployeesController < ApplicationController
  before_action :employee_unauthorized!
  before_action :authenticate_owner!
  before_action :set_take_away_store
  
  def index
    @profiles = @take_away_store.profiles
  end

  def new
    @profile = @take_away_store.profiles.build
  end

  def create
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

  def set_take_away_store
    @take_away_store = current_store
    
    if @take_away_store.id != params[:take_away_store_id].to_i
      return redirect_to root_path, alert: 'Acesso não autorizado'
    end
  end
end