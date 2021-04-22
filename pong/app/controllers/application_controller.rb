class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :error_not_found
  rescue_from ActiveRecord::RecordNotDestroyed, ActiveRecord::RecordInvalid, with: :error_invalid
  protect_from_forgery with: :null_session
  
  after_action :set_csrf_cookie
  def set_csrf_cookie
    cookies["my_csrf_token"] = form_authenticity_token
  end

  private

  def error_not_found(exception)
    model_name = exception.model.humanize
    render json: { message: "#{model_name} is not found!" }, status: :not_found
  end

  def error_invalid(exception)
    render json: { message: exception }, status: :bad_request
  end
end
