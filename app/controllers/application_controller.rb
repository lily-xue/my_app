class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user,:logined?

  def login_as(user)
     session[:user_id] = user.id
     @current_user = user
  end

  def logout
    session[:user_id] = nil
    @current_user = nil
  end

  def logined?
    current_user != nil
  end

  def current_user
    @current_user
  end

  def admin?
    @current_user.is_admin == "true"

  end

end
