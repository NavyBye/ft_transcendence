module Api
  class UsersController < ApplicationController
    skip_before_action :check_first_update, only: %i[me update]
    skip_before_action :check_second_auth, only: %i[me update]
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

      if @user.is_email_auth && !@user.auth_confirmed? && params[:is_email_auth] == 'false'
        error_msg = { type: "message", message: 'you cannot disable 2FA when have to do secondary authenticate.' }
        render json: error_msg, status: :unauthorized and return
      end

      @user.update!(update_params)
      @user.save!
      render json: @user, status: :ok
    end

    def challenge
      render json: { type: "message", message: 'not implemented yet!' }, status: :not_implemented
    end

    def game
      render json: { type: "message", message: 'not implemented yet!' }, status: :not_implemented
    end

    def histories
      @history_relations = User.find(params[:id]).history_relations.last(10)
      render status: :ok
    end

    private

    def update_params
      params.permit(:nickname, :is_banned, :is_email_auth, :image)
    end
  end
end
