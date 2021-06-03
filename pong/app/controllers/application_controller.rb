class ApplicationController < ActionController::Base
  include ApplicationHelper
  rescue_from ActiveRecord::RecordNotFound, with: :error_not_found
  rescue_from ActiveRecord::RecordNotDestroyed, ActiveRecord::RecordInvalid, with: :error_invalid
  rescue_from ChatRoomsMember::PermissionDenied, with: :error_permission_denied
  rescue_from DmRoomsMember::PermissionDenied, with: :error_permission_denied
  rescue_from Friend::PermissionDenied, with: :error_permission_denied
  rescue_from Block::PermissionDenied, with: :error_permission_denied
  rescue_from User::PermissionDenied, with: :error_permission_denied
  rescue_from Tournament::PermissionDenied, with: :error_permission_denied
  rescue_from EmailAuth::AuthenticationNotFinished, with: :need_second_authenticate
  rescue_from User::NeedFirstUpdate, with: :need_first_update
  rescue_from User::NotNewcomer, with: :nickname_not_newcomer
  rescue_from SignalChannel::InvalidFormat, with: :error_invalid
  rescue_from GameQueue::RequestedUserCanceled, with: :error_invalid
  rescue_from Game::NotPlayable, with: :not_playable
  rescue_from User::Banned, with: :banned
  rescue_from ActionController::RoutingError, with: :not_found_cover

  protect_from_forgery with: :null_session

  before_action :check_first_update
  before_action :check_second_auth
  before_action :check_banned

  def check_second_auth
    return unless user_signed_in?

    return unless current_user.is_email_auth

    User.with_advisory_lock('AUTH') do
      current_user.issue_auth_code if current_user.auth.nil?
      raise EmailAuth::AuthenticationNotFinished unless current_user.auth_confirmed?
    end
  end

  def check_banned
    return unless user_signed_in?

    raise User::Banned if current_user.is_banned
  end

  private

  def banned
    render json: { type: 'redirect', target: 'banned' }, status: :forbidden
  end

  def error_not_found(exception)
    model_name = exception.model.humanize
    render json: {
      type: "message",
      message: "#{model_name} is not found!"
    }, status: :not_found
  end

  def error_invalid(exception)
    render json: {
      type: "message",
      message: exception
    }, status: :bad_request
  end

  def error_permission_denied(_exception)
    render json: {
      type: "message",
      message: "Permssion denied"
    }, status: :forbidden
  end

  def not_found_cover
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def need_second_authenticate(_exception)
    render json: { type: 'redirect', target: 'auth' }, status: :unauthorized
  end

  def need_first_update(_exception)
    render json: { type: 'redirect', target: 'mypage' }, status: :unauthorized
  end

  def nickname_not_newcomer(_exception)
    render json: { type: 'message', message: 'new nickname should not be newcomer.' }, status: :bad_request
  end

  def not_playable(_exception)
    current_user.status_update('online') if current_user.status != 'offline'
    render json: { type: 'message', message: 'someone cannot play the pong.' }, status: :conflict
  end
end
