module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :check_first_update
    skip_before_action :check_second_auth
    def marvin
      @user = User.from_omniauth(request.env["omniauth.auth"])

      if @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        @user.issue_auth_code if @user.is_email_auth
        @user.status_update('online')
        # sign_in @user, event: :authentication
        # set_flash_message(:notice, :success, kind: "42") if is_navigational_format?
      else
        session["devise.marvin_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
  end
end
