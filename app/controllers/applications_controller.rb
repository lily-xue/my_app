class ApplicationsController < ApplicationController
  before_action :authenticate!
  before_action :admin_not_fixed, only: [:edit,:update]

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
    @application = Application.find(params[:id])
  end

  def show
  end

  def index
    if @current_user.is_admin == true   #如果当前用户为管理员，则显示所有请假信息
       @applications = Application.all.order(created_at: :desc)  #显示所有申请信息，并根据申请时间降序排列
    else
      @applications = @current_user.applications.order(created_at: :desc)  #如果当前用户是普通用户，则显示本人的所有申请信息，根据申请时间降序排序
      @application = Application.new
    end
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

  def admin_not_fixed
     @application = Application.find(params[:id])
     @application.status == "申请中"
  end

  def application_params
    params.require(:application).permit(:start_day,:end_day,:application_reasons,:admin_comments,:status)
  end
end
