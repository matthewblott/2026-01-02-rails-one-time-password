class SessionsController < ApplicationController
  skip_before_action :authenticate, only: %i[ new send_otp validate_otp create ]
  before_action :set_session, only: :destroy

  def send_otp 
    email = params[:email]
    user = User.find_by(email: email)

    if user.blank?
      user = User.new
      user.email = email
      user.save
      redirect_to about_path
    end

    otp_code = user.totp.now

    UserMailer.with(user:, otp_code:).send_otp.deliver_now
    flash[:notice] = "OTP has been sent to #{email}"

    redirect_to validate_otp_path(email: email)

  end

  def validate_otp
    @email = params[:email]
  end

  def create
    user = User.find_by(email: params[:email])

    if user&.valid_otp?(params[:otp_code])
      @session = user.sessions.create!

      if Rails.env.test?
        cookies[:session_token] = @session.id
      else
        cookies.signed.permanent[:session_token] = { value: @session.id, httponly: true }
      end

      Current.session = @session
      Current.user = user

      redirect_to root_path
    else
      flash.now[:alert] = "Invalid OTP."
      @email = params[:email]
      render :validate_otp, status: :unprocessable_entity
    end

  end

  def destroy
    @session.destroy
    flash[:notice] = "That session has been logged out"
    redirect_to sign_in_path
  end

  private

  def set_session
    session_id = cookies.signed[:session_token] || cookies[:session_token]
    return unless session_id

    @session = Session.find_by(id: session_id)
    Current.session = @session
    Current.user = @session&.user
  end

end
