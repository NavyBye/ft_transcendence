module ApplicationHelper
  def token
    {
      csrf_param: request_forgery_protection_token,
      csrf_token: form_authenticity_token
    }
  end

  def check_first_update
    raise User::NeedFirstUpdate if current_user.nickname == 'newcomer'
  end
end
