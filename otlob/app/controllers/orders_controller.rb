class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :edit, :update, :destroy]
  before_action :set_groups_friends, only: [:new, :edit]


  # GET /orders
  # GET /orders.json
  @@invitedFriends = Array.new
  def index
    @all = current_user.orders.all
    @orders = Array.new
    for order in @all
      out = Hash.new
      out[:order] = order
      out[:user] = User.find(order.user_id).name
      @orders.push(out)
    end
    @orders
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
   @res = Hash.new
   @res[:order] = @order
   @res[:users] = Array.new
   for i in @order.invitations
    @res[:users].push(i)
   end
   @res[:item] = Item.new
  end

  # GET /orders/new
  def new
    @@invitedFriends = Array.new
    @order = Order.new
      @friendships = current_user.friendships.all
      @friends = Array.new
      @friendships.each do |friendship|
      @friend = Hash.new
      @friend[:friend] = User.find(friendship.friend_id).name
      @friend[:id] = friendship.friend_id
      @friends.push(@friend)
    end
    @friends

    @groups=current_user.groups.all
  end

  # GET /orders/1/edit
  def edit
  end


  def orderDetails
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

  # POST /orders
  # POST /orders.json

  #= Append uid into invited Friends Array
  def invite
    # p @@invitedFriends
    if params[:group_id].present?
      @group = Group.find(params[:group_id])
      @result = Array.new
      for user in @group.users
        @res = Hash.new
        if @@invitedFriends.include? user.id
          @res = { error: true, message: user.name+" is already invited to order" }
        else
          @@invitedFriends.push(user.id)
          @res = { error: false, message: user.name+" invited to order", name: user.name, avatar: user.avatar.url(:thumb), id: user.id }

        end
        @result.push(@res)
      end
      render json: @result
    elsif params[:user_id].present?
      @res = Hash.new
      user = User.find(params[:user_id])
      if @@invitedFriends.include? user.id
        @res = { error: true, message: user.name+" is already invited to order" }
      else
        @@invitedFriends.push(user.id)
        @res = { error: false, message: user.name+" invited to order", name: user.name, avatar: user.avatar.url(:thumb), id: user.id }

      end
      render json: @res
    end
  end

  #= remove invited Friends Array
  def uninvite
    if @@invitedFriends.include? params[:uId].to_i
      @user = User.find(params[:uId].to_i)
      if @@invitedFriends.delete(params[:uId].to_i)
        render json: {error: false, message: @user.name+" un inveited from order" }
      else
        render json: {error: true, message: "can't un invite "+@user.name+" to order" }
      end
    else
      render json: {error: true, message: @user.name+"is not invited to order" }
    end
  end

  def create
    p order_params
    @order = Order.new(order_params)
    @order.mtype=params[:mtype]
    @order.user_id=current_user.id
    @order.status = 0
    @result = Hash.new
    respond_to do |format|
      if @order.save
        @result[:order] = @order
        @result[:users] = Array.new
        for friend in @@invitedFriends
          @friend = User.find(friend)
          @res = inviteToOrder(@order,@friend)
          if !@res[:error]
            @result[:users].push(@res[:user])
          end
        end
        @userFriends = @current_user.friendships.all
        @userFriends.each do |f|
        ActionCable.server.broadcast "uni_brod_#{f.friend_id}_channel" , @order
        end
        @usersInsideOrder = @order.invitations.all
        @usersInsideOrder.each do |u|
        ActionCable.server.broadcast "uni_brod_#{u.user_id}_channel" , {type:"orderInvitation", Notification: current_user.name+" invited yo to an order named "+@order.restaurant}
        end

        format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
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
  # end

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
    @orders = current_user.orders.all.order("created_at DESC").limit(5)
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    p "helloFromDestroy"
    @usersInsideOrder = @order.invitations.all
    if @order.user_id == current_user.id
      @usersInsideOrder.each do |user|
        ActionCable.server.broadcast "uni_brod_#{user.user_id}_channel" , {type:"orderDestroyed", Notification: current_user.name+" Destroyed a order named "+@order.restaurant}
      end
      @order.destroy
      respond_to do |format|
        format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
        format.json { head :no_content }
      end
    else
       if user_signed_in?
        redirect_to order_path(), notice: "Only Owner Who Can Delete The Order"
      else
        redirect_to new_user_session_path
      end
    end
  end

  def finish
    p params[:id]
    @order = Order.where(id:params[:id]).update_all(status: 1)
  end

  def cancel
    p params[:id]
    @order = Order.where(id:params[:id]).update_all(status: 2)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Gets the groups and friends of current user before creating or editing order
    def set_groups_friends
      @friendships = current_user.friendships.all
        @friends = Array.new
        @friendships.each do |friendship|
        @friend = Hash.new
        @friend[:friend] = User.find(friendship.friend_id).name
        @friend[:id] = friendship.friend_id
        @friends.push(@friend)
      end
      @friends
      @groups=current_user.groups.all
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:menu, :mtype, :restaurant, :user_id)
    end

    # Check if friend is already invited to order
    def check_in_order(order,friend)
      for invitation in order.invitations
        if invitation.user.id == friend.id
          return true
        end
      end
      return false
    end

    # invites friend to order
    def inviteToOrder(order,friend)
      @friend = friend
      @order = order
      @res = Hash.new

      if @friend.present?
        if check_in_order(@order,@friend)
          @res = { error: true, message: @friend.name+" is already a invited to the Order" }
        else
          @invitation = Invitation.new
          @invitation.order = @order
          @invitation.user = @friend
          @invitation.status = 0

          if @invitation.save
            @res = { error: false, user: @friend }
          else
            @res = { error: true, message: "Unable to invite "+@friend.name+" to order" }
          end
        end
      else
        @res = {error: true, message: @friend.name+" doesn't exist"}
      end
      return @res
    end
  end
