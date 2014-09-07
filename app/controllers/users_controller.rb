class UsersController < ApplicationController
  def new
    if current_user
      redirect_to activity_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thank you for signing up for Ribbit!"
    else
      render "new"
    end
  end

  def index
    @users = User.all
    @ribbit = Ribbit.new
  end

  def activity
    if current_user
      @ribbit = Ribbit.new
      buddies_ids = current_user.followeds.map(&:id).push(current_user.id)
      @ribbits = Ribbit.where(user_id: buddies_ids)
    else
      redirect_to root_url
    end
  end

  def show
    @user = User.find(params[:id])
    @ribbit = Ribbit.new
    @relationship = Relationship.where(
      follower_id: current_user.id,
      followed_id: @user.id
    ).first_or_initialize if current_user
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :name, :bio, :avatar_url)
  end
end
