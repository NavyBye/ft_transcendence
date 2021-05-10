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
      match_make
      render json: {}, status: :no_content
    end

    def cancel
      find_queue current_user.id
    end

    private

    def availability_check
      # if target is exist, check if target user is playable.
      return GameQueue.playable?(User.find(params[:target_id])) unless params[:target_id].nil?

      # self playable check
      GameQueue.playable?(current_user)
    end

    def queue_params
      {
        game_type: params[:game_type],
        addon: params[:addon],
        target_id: params[:target_id],
        user_id: current_user.id
      }
    end

    def match_make
      game = nil
      GameQueue.transaction do
        if GameQueue.queue_is_empty?(params[:game_type], params[:addon])
          GameQueue.push params
        else
          game = GameQueue.pop_and_match params
        end
      end
      game_start(game) unless game.nil?
    end

    def find_queue(id)
      @queue = GameQueue.find_by user_id: id
    end

    def game_start(game)
      game.players.each do |player|
        player.status_update 'game'
        # TODO : player.send_start_signal
      end
    end
  end
end
