class ApplicationsController < ApplicationController
  before_action :authenticate!
  before_action :admin_not_fixed, only: [:edit,:update]
  after_action :sendmail_for_application_update, only: [:update]
  after_action :sendmail_for_application_create, only: [:create]
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
   if !@current_user.is_admin? && application.status == "申请中"
      application.update(application_params_reasons)
    elsif @current_user.is_admin? && application.status != "申请中"
      application.update(application_params_comments)
    elsif @current_user.is_admin? && application.status == "申请中"
      application.update(application_params_comment_status)
    end
    redirect_to applications_path
  end

  private
  def authenticate! #必须登录才可以修改申请
      @current_user = User.find_by(id: session[:user_id])
    if @current_user.blank?
      redirect_to login_path and return
    end
  end

  def admin_not_fixed_add_correct_applier
     @application = Application.find(params[:id])
     redirect_to(root_path) unless (@application.status == "申请中" && @current_user == @application.user) || @current_user.is_admin?
  end

  def sendmail_for_application_update  #申请状态变化,发邮件给申请人
      Sendmail.sendmail_for_application(@application.user).deliver
  end

  def sendmail_for_application_create #新建申请时,发邮件给所有管理员
      admins = User.where(is_admin: true)
      admins.each  do |admin|
      Sendmail.sendmail_for_application(admin).deliver
      puts admin.name
      end
  end

  def application_params   #新建申请时的参数
    params.require(:application).permit(:start_day,:end_day,:application_reasons,:admin_comments,:status)
  end

  def application_params_comment_status
    params.require(:application).permit(:admin_comments, :status)
  end

  def application_params_comments
    params.require(:application).permit(:admin_comments)
  end

  def application_params_reasons
    params.require(:application).permit(:application_reasons)
  end
end
