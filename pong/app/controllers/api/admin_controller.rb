class Api::AdminController < ApplicationController
  before_action :authenticate_user!

  def designate
    @user = User.find params[:id]
    render json: {}, status: :ok and return if designate_possible
  end

  def ban
    @user = User.find params[:id]
    render json: {}, status: :ok and return if check_ban_permission
  end

  private

  def check_ban_permission
    User.roles[current_user.role] > User.roles[@user.role]
  end

  def designate_possible
    # raise permissiondenied
    # unless User.roles[current_user.role] > User.roles[params[:role]]
    # && User.roles[current_user.role] > User.roles[@user.role]
    true
  end
end
