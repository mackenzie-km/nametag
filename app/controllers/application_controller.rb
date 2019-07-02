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

  def check_admin(level)
    if level != current_user.admin_level
      flash[:message] = "You are not authorized to view the previous page."
      redirect_to root_path
    end
  end

  def redirect_if_no_login
    if !current_user
      flash[:message] = "You need to sign in before viewing this page."
      redirect_to "/login"
    end
  end

end
