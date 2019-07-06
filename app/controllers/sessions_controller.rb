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
      flash[:message] = "This password/email combination is invalid. Try again - or try logging in via Google."
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end

  def googleAuth
    access_token = request.env["omniauth.auth"]
    @user = User.from_omniauth(access_token)
    @user.save
    # Access_token is used to authenticate request made from the rails application to the google server
    @user.google_token = access_token.credentials.token
    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    @user.google_refresh_token = refresh_token if refresh_token.present?
    session[:user_id] = @user.id
    redirect_to contacts_path
  end
end
