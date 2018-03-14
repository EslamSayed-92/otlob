class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
    @group = Group.new
    @users = User.all
  end

  #= Function to Remove friend from Group
  def removeFromGroup
    @group = Group.find(params[:gid])
    @friend = User.find(params[:uid])
    @res = Hash.new
    if @group.users.delete(@friend)
      @res = {userfriend: @friend, error: false, message: @friend.name+" removed from "+@group.name+" group" }
    else
      @res = {userfriend: @friend, error: true, message: "Unable to remove "+@friend.name+" from "+@group.name+" group" }
    end
    render json: @res
  end


  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
    @users = User.all
    # @data = { group: @group, users: @users }
    # p @data
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    # group_params[:user] = User.find(current_user.id)
    @group = Group.new(group_params)
    @group.user = current_user

    respond_to do |format|
      if @group.save
        @group.users.push(current_user)

        format.html { redirect_to groups_url, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :index }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  #= Function to Add friend To Group from Add Friend form
  def addToGroup
    @friend = User.where(email: params[:fmail]).take
    @group = Group.find(params[:group])
    @res = Hash.new
    if @friend.present?
      if !check_if_friend(@friend.id)
        @res = { error: true, message: "You are not friend to "+@friend.email+" to add to Group" }
      elsif check_in_group(@group,@friend)
        @res = { error: true, message: @friend.name+" is already a member in the Group" }
      else
        @added = @group.users.push(@friend)
        if @added
          @res = { error: false, message: @friend.name+" added to "+@group.name+" group" }
        else
          @res = { error: true, message: "Unable to add "+@friend.email+" to "+@group.name+" group" }
        end
      end
    else
      @res = {error: true, message: params[:fmail]+" doesn't exist"}
    end
    render json: @res
  end


  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name,:user)
    end


    def check_if_friend(friend_id)
      @friendship = Friendship.where(user_id: current_user.id, friend_id: friend_id).take
      if @friendship.present?
        return true
      else
        return false
      end
    end

    def check_in_group(group,friend)
      for user in group.users
        if user.id == friend.id
          return true
        end
      end
      return false
    end
end
