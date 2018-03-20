class WelcomeController  < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
  	@orders = Order.all.order("created_at DESC").limit(3)
  end
end
