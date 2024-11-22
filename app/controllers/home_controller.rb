class HomeController < ApplicationController
  before_action :prevent_double_access!, only: [:create_account, :sign_in_account]
  before_action :employee_unauthorized!, only: %i[owner]
  before_action :unauthenticated_user!, only: %i[search_order]

  def index
    if authorized_user? && current_store.present?
      setup_store_context
      @order_items, @price = load_cart_session
      @menu = @owner.menus.build
    end
  end

  def create_account; end

  def sign_in_account; end

  def search_order
    @order = Order.find_by(code: params[:query])
    @take_away_store = @order&.take_away_store
  end

  def owner
    @owner = current_owner
  end

  private

  def setup_store_context
    @employee = current_employee if employee_signed_in?
    @take_away_store = current_store
    @owner = @take_away_store.owner
    @menus = @owner.menus
    @items = @take_away_store.items.select(&:active?)
  end
end