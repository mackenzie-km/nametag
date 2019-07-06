class SessionsController < ApplicationController

  before_action :redirect_if_logged_in, only: [:new, :create]
  before_action :redirect_if_no_login, only: [:destroy]

  def new
  end

  def create
    @user = User.find_by(email: params[:user][:email])
    @user = @user.try(:authenticate, params[:user][:password])
    if @user
      session[:user_id] = @user.id
      redirect_to contacts_path
    else
      flash[:message] = "This password/email combination is invalid."
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end
