module Api
  class UsersController < ApplicationController
    before_action :authenticate_user!
    def index
      render json: User.all, status: :ok
    end

    def rank
      render json: User.all.order(rating: :desc), status: :ok
    end

    def show
      @user = User.find(params[:id])
      render json: @user, status: :ok
    end

    def me
      @user = User.find(current_user.id)
      render json: @user, status: :ok
    end

    def update
      @user = User.find(params[:id])
      raise User::PermissionDenied unless current_user.id == @user.id

      @user.update!(update_params)
      @user.save!
      render json: @user, status: :ok
    end

    def challenge
      render json: { error: 'not implemented yet!' }, status: :not_implemented
    end

    def game
      render json: { error: 'not implemented yet!' }, status: :not_implemented
    end

    def history
      render json: { error: 'not implemented yet!' }, status: :not_implemented
    end

    private

    def update_params
      params.permit(:nickname, :is_banned, :is_email_auth, :image)
    end
  end
end
