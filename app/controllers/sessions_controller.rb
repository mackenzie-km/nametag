class SessionsController < ApplicationController

  before_action :redirect_if_logged_in, only: [:new, :create]
  before_action :redirect_if_no_login, only: [:destroy]

  def new
  end

# tries to find and authenticate user to create a new session
  def create
    @user = User.find_by(email: params[:user][:email])
    @user = @user.try(:authenticate, params[:user][:password])
    if @user
      session[:user_id] = @user.id
      redirect_to contacts_path
    else
      flash.now[:alert] = "Invalid combination. Try again - or try logging in via Google"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

# uses googleAuth code to create a user from omniauth, set tokens, and set session id
  def googleAuth
    access_token = request.env["omniauth.auth"]
    @user = User.from_omniauth(access_token)
    @user.save
    @user.google_token = access_token.credentials.token
    refresh_token = access_token.credentials.refresh_token
    @user.google_refresh_token = refresh_token if refresh_token.present?
    session[:user_id] = @user.id
    redirect_to contacts_path
  end
end
