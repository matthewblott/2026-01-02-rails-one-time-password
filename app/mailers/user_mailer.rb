class UserMailer < ApplicationMailer
  def send_otp
    @user = params[:user]
    @otp_code = params[:otp_code]
    mail(
      to: @user.email,
      subject: "#{@otp_code} - Your one-time code"
    )
  end

end
