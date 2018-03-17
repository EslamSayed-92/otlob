class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new
    @orderId = @order.id
      @friendships = current_user.friendships.all
      @friends = Array.new
      @friendships.each do |friendship|
      @friend = Hash.new
      @friend[:avatar] = User.find(friendship.friend_id).avatar
      @friend[:friend] = User.find(friendship.friend_id).name
      @friend[:id] = friendship.id
      @friends.push(@friend)
    end
    @friends
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  def create
    p params
    @order = Order.new(order_params)
    @order.mtype=params[:mtype]
    @order.user_id=current_user.id
    @order.status=0
    if @order.save
      data={orderId:@order.id,friends:params}
      redirect_to @order, notice: 'Order was successfully created.' 
    else
      respond_to do |format|
      format.html { render :new }
      format.json { render json: @order.errors, status: :unprocessable_entity }
    end
  end

  # def index
  #   respond_to do |format|
  #     if @order.save
  #       # get all friends ids and send order to them
  #       @friends = current_user.friendships.all
  #       @friends.each do |friend|
  #         ActionCable.server.broadcast "uni_brod_#{friend.friend_id}_channel" , @order
  #       end
  #       format.html { redirect_to @order, notice: 'Order was successfully created.' }
  #       format.json { render :show, status: :created, location: @order }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @order.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end 
   end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    if @order.user_id == current_user.id
          respond_to do |format|
          if @order.update(order_params)
            format.html { redirect_to @order, notice: 'Order was successfully updated.' }
            format.json { render :show, status: :ok, location: @order }
          else
            format.html { render :edit }
            format.json { render json: @order.errors, status: :unprocessable_entity }
          end
        end
    else
      if user_signed_in?
        redirect_to order_path(),
          notice: "Only Owner Who Can Edit The Order"
      else
        redirect_to new_user_session_path
      end
    end
  end

  def ordersList
    @orders = Order.all.order("created_at DESC").limit(5)
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    if @order.user_id == current_user.id
      @order.destroy
      respond_to do |format|
        format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
       if user_signed_in?
        redirect_to order_path(),
          notice: "Only Owner Who Can Delete The Order"
      else
        redirect_to new_user_session_path
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:menu, :mtype, :restaurant, :user_id)
    end
end
