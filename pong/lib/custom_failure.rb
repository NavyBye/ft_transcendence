class CustomFailure < Devise::FailureApp
  def http_auth
    super
    self.content_type = "application/json"
    self.response_body = { type: 'message', message: 'login failed. wrong email or password!' }.to_json
  end
end
