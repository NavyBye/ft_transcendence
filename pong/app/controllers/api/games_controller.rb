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
      GameQueue.with_advisory_lock('queue') do
        find_queue current_user.id
        @queue.destroy
      end
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
      @game = nil
      if params[:game_type] == 'duel' || params[:game_type] == 'ladder'
        queue_based_matchmaking
      elsif params[:game_type] == 'ladder_tournament' || params[:game_type] == 'friendly'
        request_based_matchmaking
      elsif params[:game_type] == 'tournament'
        tournament_matchmaking
      else
        war_matchmaking
      end
      game_start(@game) unless @game.nil?
    end

    def queue_based_matchmaking
      GameQueue.transaction do
        GameQueue.with_advisory_lock('queue') do
          if GameQueue.queue_is_empty?(params[:game_type], params[:addon])
            GameQueue.push queue_params
          else
            @game = GameQueue.pop_and_match queue_params
          end
        end
      end
    end

    def request_based_matchmaking
    end

    def tournament_matchmaking
      # TODO : Tournament.first
    end

    def war_matchmaking
      # TODO : War.current
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
