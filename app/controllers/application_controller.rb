class ApplicationController < ActionController::Base
  def index
  end

  private
  def current_user
    User.find(session[:user_id])
  end

  def check_admin(level)
    if level != current_user.admin_level
      flash[:message] = "You are not authorized to view the previous page."
      redirect_to root_path
    end
  end

end
