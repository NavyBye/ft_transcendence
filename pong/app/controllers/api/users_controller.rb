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
      current_user.update!(rank: User.initial_rank) if current_user.rank.nil?
      rank = current_user.rank
      render json: {}, status: :ok and return if rank == 1

      @candidates = User.where(rank: rank - 1)
      @candidates = @candidates.sample(3) if rank > 3
      render json: @candidates, status: :ok
    end

    def game
      @game_player = GamePlayer.where(user_id: params[:id])
      render json: {}, status: :ok and return if @game_player.empty?

      render status: :ok
    end

    def histories
      @history_relations = User.find(params[:id]).history_relations.order(created_at: :asc).last(10)
      render status: :ok
    end

    def who
      user = User.where(nickname: params[:nickname]).first!
      render json: user, status: :ok
    end

    private

    def update_params
      raise User::NotNewcomer if params[:nickname] == 'newcomer'

      params.permit(:nickname, :is_banned, :is_email_auth, :image)
    end
  end
end
