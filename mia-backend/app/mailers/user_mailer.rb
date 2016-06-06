class UserMailer < ApplicationMailer

  def invite(user:, password:)
    @user = user
    @password = password
    mail(to: @user.email, subject: "You've been invited to try MIA")
  end

  def reset_password(user:)
    @user = user
    mail(to: @user.email, subject: "Reset your MIA password")
  end

end
