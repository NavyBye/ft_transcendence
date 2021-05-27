class CustomFailure < Devise::FailureApp
  def http_auth
    super
    self.content_type = "application/json"
    self.response_body = { type: 'message', message: 'LOGIN FAILURE' }.to_s
  end
end
