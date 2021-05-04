module Api
  class AuthController < ApplicationController
    before_action :authenticate_user!

    def match
      email_auth = EmailAuth.find_by(user_id: current_user.id)
      if email_auth.match_code(params)
        render json: {}, status: :ok
      else
        render json: {
          type: 'message',
          message: 'authenticate code is invalid.'
        }, status: :bad_request
      end
    end
  end
end
