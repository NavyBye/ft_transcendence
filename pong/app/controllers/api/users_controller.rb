module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!
    def index
      render json: User.all
    end

    def rank
      render json: User.all.order(rating: :desc).page(params[:page])
    end

    def show
      @user = User.find(show_params)
      render json: @user, status: :ok
    end

    def update
      @user = User.find(show_params)
      @user.update(update_params)
      render json: @user, status: :ok
    end

    private

    def show_params
      params.require(:id)
    end

    def update_params
      params.require(:id)
            .permit(:nickname, :is_banned, :is_email_auth)
    end
  end
end
