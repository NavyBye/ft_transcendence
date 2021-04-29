module Api
  class FriendsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_permission, only: %i[create destroy]

    def index
      user = User.find(params[:user_id])
      @friends = user.followings
      render json: @friends.as_json(only: %i[id name nickname status]), status: :ok
    end

    def create
      @friendship = Friend.create!(friendship_params)
      render json: @friendship, status: :created
    end

    def destroy
      result = Friend.find_by(friendship_params)
      result.destroy!
      render json: { message: 'successfully deleted.' }, status: :no_content
    end

    private

    def friendship_params
      params.permit(:user_id, :follow_id)
    end

    def check_permission
      is_admin = false # TODO : admin/owner check.
      raise Friend::PermissionDenied if Integer(params[:user_id]) != Integer(current_user.id) && !is_admin
    end
  end
end
