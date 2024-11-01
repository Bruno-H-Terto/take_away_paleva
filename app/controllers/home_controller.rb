class HomeController < ApplicationController
  def index; end

  def owner
    @owner = current_owner
  end
end