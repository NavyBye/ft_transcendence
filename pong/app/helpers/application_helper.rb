module ApplicationHelper
  def token
    {
      csrf_param: request_forgery_protection_token,
      csrf_token: form_authenticity_token
    }
  end
end
