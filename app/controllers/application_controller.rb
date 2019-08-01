class ApplicationController < ActionController::Base

# application root
  def index
  end

  private

  # return current user by session id
  def current_user
    if !session[:user_id] then nil else User.find(session[:user_id]) end
  end

# redirects to index with error if no current user
  def redirect_if_no_login
    if !current_user
      flash[:notice] = "You need to sign in before viewing this page."
      redirect_to root_path
    end
  end

# redirects to index with error if required access level is too high
  def redirect_if_not_access(level)
    if has_access?(level) != true
      flash[:notice] = "You do not have access to the selected page."
      redirect_to root_path
    end
  end

# redirects to index with error if you go to login/signup page while logged in
  def redirect_if_logged_in
    if !!current_user
      flash[:notice] = "You are already logged in."
      redirect_to root_path
    end
  end

# returns false if required access level is too high - & vice versa
  def has_access?(level)
    if level > (current_user.try(:admin_level) || 0) then return false else return true end
  end

# returns admin level if logged in
  def user_admin_level
    if !!current_user
      @user_admin_level = User.find(session[:user_id]).admin_level
    end
  end

end
