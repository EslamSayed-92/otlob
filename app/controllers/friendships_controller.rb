class FriendshipsController < ApplicationController
  before_action :set_friendship, only: [:show, :edit, :update, :destroy]

  # GET /friendships
  # GET /friendships.json
  def index
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

  #= Function to find friend from Add Friend form
  def find
    @friend = User.where(email: params[:fmail].downcase).take
    @res = Hash.new
    if @friend.present?
      if check_if_self @friend.id
        @res = { error: true, message: "Can't Be Friend of your self !!" }
      elsif check_if_friend @friend.id
        @res = { error: true, message: @friend.name+" is already in your friend list" }
      else
        @friendship = current_user.friendships.build(:friend_id => @friend.id)
        if @friendship.save
          @res = { error: false, message: @friend.name+" added to your friend list" }
          #ActionCable.server.broadcast "uni_brod_#{current_user.id}_channel" , {addedToYourFriend: @friend,friendShip:@friendship}
          #ActionCable.server.broadcast "uni_brod_#{@friend.id}_channel" , {type:"friendAdd", Notification: current_user.name+" added you as friend"}
        else
          @res = { error: true, message: "Unable to add "+@friend.email+" to your friend list" }
        end
      end
    else
      @res = {error: true, message: params[:fmail]+" doesn't exist"}
    end
    render json: @res
  end

  def create
    p params
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id])
    if @friendship.save
      flash[:notice] = "Added friend."
      redirect_to root_url
    else
      flash[:error] = "Unable to add friend."
      redirect_to root_url
    end
  end

  def destroy
    @friendship = current_user.friendships.find(params[:id])
    #ActionCable.server.broadcast "uni_brod_#{@friendship.friend_id}_channel" , {type:"friendDelete", Notification: current_user.name+"unfriend you"}
    @friendship.destroy
    redirect_to friendships_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friendship
      @friendship = Friendship.find(params[:id])
    end

    def check_if_friend(friend_id)
      @friendship = Friendship.where(user_id: current_user.id, friend_id: friend_id).take
      if @friendship.present?
        return true
      else
        return false
      end
    end

    def check_if_self(friend_id)
      if friend_id == current_user.id
        return true
      else
        return false
      end
    end

  #   # Never trust parameters from the scary internet, only allow the white list through.
  #   def friendship_params
  #     params.require(:friendship).permit(:user_id, :friend_id)
  #   end
end
