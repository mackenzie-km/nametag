class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(name: params[:user][:email])
    @user = @user.try(:authenticate, params[:user][:password])
    if @user.valid
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
