class Sendmail < ApplicationMailer

  def sendmail_for_application(user)
  @user = user
  mail(to: @user.email,subject:'请假申请信息变更通知')
  end
end
