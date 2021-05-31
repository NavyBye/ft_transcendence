class HomeController < ApplicationController
  skip_before_action :check_first_update
  skip_before_action :check_second_auth
  skip_before_action :check_banned
  def index; end
end
