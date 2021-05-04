class AuthMailer < ApplicationMailer
  def auth_email
    @auth = params[:auth]
    mail to: @auth.user.email, subject: '[42AirForceBye] Authentication needed.'
  end
end
