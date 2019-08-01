class UsersController < ApplicationController

  before_action only: [:index, :edit, :update, :destroy] do redirect_if_not_access(2) end
  before_action :redirect_if_logged_in, only: [:new, :create]
  before_action :find_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(email: user_params[:email], password: user_params[:password])
    @user.admin_level=(user_params[:admin_level])
    if @user.save
      session[:user_id] = @user.id
      redirect_to contacts_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    enter_code
    redirect_to users_path
  end

  def destroy
    @user.delete
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:email, :password, :admin_level)
  end

  def enter_code
    code = user_params[:admin_level].to_i
    if code == 2
      @user.admin_level=(ENV['ADMIN'])
    elsif code == 1
      @user.admin_level=(ENV['IGSM'])
    else
      @user.admin_level=(0)
    end
      @user.save
  end

  def find_user
    @user = User.find(params[:id])
  end
end
