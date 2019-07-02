class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
  end

  def create
    user = User.new(email: user_params[:email], password: user_params[:password])
    user.admin_level=(user_params[:admin_level])
    if user.save
      redirect_to contacts_path
    else
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.admin_level = params[:user][:admin_level]
    if @user.save
      redirect_to users_path
    else
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.delete
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :admin_level)
  end
end
