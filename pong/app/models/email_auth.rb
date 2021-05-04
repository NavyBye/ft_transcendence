class EmailAuth < ApplicationRecord
  class AuthenticationNotFinished < StandardError; end

  belongs_to :user, class_name: "User"

  def match_code(params)
    if params[:code] == code
      update!(confirm: true)
      true
    else
      false
    end
  end
end
