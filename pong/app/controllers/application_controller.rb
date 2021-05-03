class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :error_not_found
  rescue_from ActiveRecord::RecordNotDestroyed, ActiveRecord::RecordInvalid, with: :error_invalid
  rescue_from ChatRoomsMember::PermissionDenied, with: :error_permission_denied
  rescue_from DmRoomsMember::PermissionDenied, with: :error_permission_denied
  rescue_from Friend::PermissionDenied, with: :error_permission_denied
  rescue_from Block::PermissionDenied, with: :error_permission_denied
  rescue_from User::PermissionDenied, with: :error_permission_denied

  protect_from_forgery with: :null_session

  private

  def error_not_found(exception)
    model_name = exception.model.humanize
    render json: { message: "#{model_name} is not found!" }, status: :not_found
  end

  def error_invalid(exception)
    render json: { message: exception }, status: :bad_request
  end

  def error_permission_denied(_exception)
    render json: { message: "Permssion denied" }, status: :forbidden
  end

  def need_second_authenticate(_exception)
    render json: { type: 'redirect', redirect: 'auth' }, status: :unauthorized
  end

  def need_first_update(_exception)
    render json: { type: 'redirect', redirect: 'mypage' }, status: :unauthorized
  end
end
