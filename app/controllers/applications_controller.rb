class ApplicationsController < ApplicationController
  before_action :authenticate!
  before_action :admin!, only: [:edit,:update]
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
       @applications = Application.paginate(page: params[:page],per_page: 10)
    else
      @applications = @current_user.applications.paginate(page: params[:page],per_page: 10)  #如果当前用户是普通用户，则显示本人的所有申请信息，根据申请时间降序排序
      @application = Application.new
    end
  end

  def update
    application = Application.find(params[:id])
    if @current_user.is_admin? && application.status == "申请中"#管理员更新状态，可以同事更新备注和状态
      application.update(application_params_comment_status)
    end
    redirect_to applications_path
  end

  private

  def admin!
  redirect_to applications_path unless @current_user.is_admin?
  end

  def admin_not_fixed
   @application = Application.find(params[:id])
   @application.status == "申请中"
  end

  def admin_not_fixed_add_correct_applier
     @application = Application.find(params[:id])
     redirect_to(root_path) unless (@application.status == "申请中" && @current_user == @application.user) || @current_user.is_admin?
  end


  def sendmail_for_application_update  #申请状态变化,发邮件给申请人
   begin  #错误处理程序，如果发送邮件失败，报错
       @application = Application.find(params[:id])
       Sendmail.sendmail_for_application(@application.user).deliver
  rescue
       flash[:notice] = "发送邮件失败"
  end
  end

  def sendmail_for_application_create #新建申请时,发邮件给所有管理员
      admin = User.where(is_admin: true)

      puts admin
      # admins.each  do |admin|
      #   begin
      Sendmail.sendmail_for_application(admin).deliver
      #   rescue
      #     flash[:notice] = "发送邮件给#{admin.name}失败"
      #   end

      # end
  end

  def application_params   #新建申请时的参数
    params.require(:application).permit(:start_day,:end_day,:application_reasons,:admin_comments,:status)
  end

  def application_params_comment_status
    params.require(:application).permit(:admin_comments, :status)
  end
end
