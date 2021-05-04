class EmailAuth < ApplicationRecord
  class AuthenticationNotFinished < StandardError; end

  belongs_to :user, class_name: "User"
end
