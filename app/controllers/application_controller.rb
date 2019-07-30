class ApplicationController < ActionController::Base

  def index
  end

  private
  def current_user
    if !session[:user_id] then nil else User.find(session[:user_id]) end
  end

  def redirect_if_no_login
    if !current_user
      flash.now[:alert] = "You need to sign in before viewing this page."
      render "application/index"
    end
  end

  def redirect_if_not_admin
    if has_access?(2) != true
      flash.now[:alert] = "You do not have access to the selected page."
      render "application/index"
    end
  end

  def redirect_if_logged_in
    if !!current_user
      flash.now[:alert] = "You are already logged in."
      render "application/index"
    end
  end

  def has_access?(level)
    redirect_if_no_login
    if level > current_user.admin_level then false else true end
  end

  def user_admin_level
    @user_admin_level = User.find_by(id: session[:user_id]).admin_level
  end

end
