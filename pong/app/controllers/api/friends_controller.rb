module Api
  class FriendsController < ApplicationController
    before_action :authenticate_user!

    def index
      user = User.find(params[:user_id])
      @friends = user.followings
      render json: @friends.as_json(only: %i[id name status]), status: :ok
    end

    def create
      @friendship = Friend.create(friendship_params)
      render json: @friendship, status: :created
    end

    def destroy
      result = Friend.find_by(friendship_params)
      result.destroy
      render json: { message: 'successfully deleted.' }, status: :no_content
    end

    private

    def friendship_params
      params.require(:user_id, :follow_id)
    end
  end
end
