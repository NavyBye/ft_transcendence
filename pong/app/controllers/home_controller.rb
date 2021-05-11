class HomeController < ApplicationController
  skip_before_action :check_first_update
  skip_before_action :check_second_auth
  def index; end
end
