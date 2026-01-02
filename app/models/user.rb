class User < ApplicationRecord
  before_create :generate_totp_secret

  def totp
    ROTP::TOTP.new(totp_secret, issuer: "Scribble")
  end

  def generate_totp_secret
    self.totp_secret ||= ROTP::Base32.random_base32
  end

  def valid_otp?(code)
    totp.verify(code, drift_behind: 30)
  end

  has_many :sessions, dependent: :destroy

end
