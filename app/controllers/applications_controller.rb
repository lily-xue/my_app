class ApplicationsController < ApplicationController
  before_action :authenticate!
  def new
    @applications = @current_user.applications
    @application = Application.new
  end

  def create
    application = Application.new(application_params)
  # 设定 application 的 user_id 就是当前用户的 id
    application.user_id = @current_user.id
  if application.save!
    redirect_to applications_path
  end
  end

  def edit
  end

  def show
  end

  def index
    @applications = @current_user.applications
    @application= Application.new
  end

  def update
    application = Application.find(params[:id])
    application.update(application_params)
    redirect_to applications_path
  end

  private
  def authenticate!
    @current_user = User.find_by(id: session[:user_id])
    if @current_user.blank?
      redirect_to login_path and return
    end
  end

  def application_params
    params.require(:application).permit(:start_day,:end_day,:application_reasons,:admin_comments,:status)

  end
end
