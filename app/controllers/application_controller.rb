class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user,:logined?,:authenticate!

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

  def authenticate! #必须登录才可以修改申请
      @current_user = User.find_by(id: session[:user_id])
    if @current_user.blank?
      redirect_to login_path and return
    end
  end
  # def admin?
  #   @current_user.is_admin == "true"
  #
  # end

  def current_user?(user)
    user == @current_user
    puts "#{@current_user}"
  end

end
