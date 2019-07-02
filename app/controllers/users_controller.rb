class UsersController < ApplicationController

  before_action :redirect_if_not_admin, only: [:index, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
  end

  def create
    user = User.new(email: user_params[:email], password: user_params[:password])
    user.admin_level=(user_params[:admin_level])
    if user.save
      session[:user_id] = user.id
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
    enter_code
    if @user.valid?
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

  def enter_code
    if params[:user][:admin_level].to_i == 2
      @user.update(admin_level: ENV['ADMIN'])
    elsif params[:user][:admin_level].to_i == 1
      @user.update(admin_level: ENV['IGSM'])
    else
      @user.update(admin_level: 0)
    end
  end
end
