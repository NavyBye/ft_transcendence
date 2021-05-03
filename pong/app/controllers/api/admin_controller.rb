module Api
  class AdminController < ApplicationController
    before_action :authenticate_user!
    before_action :identify_user

    def designate
      check_designate_permission
      @user.update!(role: params[:role])
      render json: @user, status: :ok
    end

    def ban
      check_ban_permission
      @user.update!(is_banned: params[:is_banned])
      render json: @user, status: :ok
    end

    private

    def check_ban_permission
      raise User::PermissionDenied unless User.roles[current_user.role] > User.roles[@user.role]
    end

    def check_designate_permission
      my_role = User.roles[current_user.role]
      target_role = User.roles[params[:role]]
      source_role = User.roles[@user.role]
      raise User::PermissionDenied unless my_role > target_role && my_role > source_role
    end

    def identify_user
      @user = User.find params[:id]
    end
  end
end
