class WelcomeController < ApplicationController
  before_action :authenticate_user!
  def index
  	@orders = Order.all.order("created_at DESC").limit(3)
  end
end
