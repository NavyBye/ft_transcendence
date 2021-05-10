module Api
  class GamesController < ApplicationController
    before_action :authenticate_user!

    def index
      render json: Game.all
    end

    def show
      @game = Game.find params[:id]
      render json: @game
    end

    def create
      availability_check
      @new_queue = GameQueue.create(queue_params)
      # TODO : wait OR start game
      render json: {}, status: :no_content
    end

    def cancel
      find_queue current_user.id
    end

    private

    def availability_check
      return false unless GameQueue.playable?(current_user)

      return false if params[:user_id].blank? && GameQueue.playable?(User.find(params[:user_id]))
      # type check
    end

    def queue_params
      params.permit(:game_type, :addon, :user_id)
    end

    def find_queue(id)
      @queue = GameQueue.find_by user_id: id
    end
  end
end
