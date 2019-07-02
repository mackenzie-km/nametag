class ApplicationController < ActionController::Base
  def index
  end

  private
  def current_user
    if !session[:user_id]
      nil
    else
      User.find(session[:user_id])
    end
  end

  def has_access?(level)
    if level > current_user.admin_level
      false
    else
      true
    end
  end

  def redirect_if_no_login
    if !current_user
      flash[:message] = "You need to sign in before viewing this page."
      redirect_to "/login"
    end
  end

  def redirect_if_not_admin
    if has_access?(2) != true
      flash[:message] = "You do not have access to this page."
      redirect_to root_path
    end
  end

end
