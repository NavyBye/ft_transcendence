# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    before_action :configure_sign_in_params
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      render json: {
        csrf_param: request_forgery_protection_token,
        csrf_token: form_authenticity_token
      }, status: :ok
    end

    # DELETE /resource/sign_out
    def destroy
      # signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
      if Devise.sign_out_all_scopes
        sign_out
      else
        sign_out(resource_name)
      end
      render json: {
        csrf_param: request_forgery_protection_token,
        csrf_token: form_authenticity_token
      }, status: :ok
    end

    protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    end
  end
end
