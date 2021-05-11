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
      case params[:game_type]
      when 'duel', 'ladder', 'ladder_tournament', 'friendly'
        basic_matchmaking
      when 'tournament'
        tournament_matchmaking
      else # war
        war_matchmaking
      end
      game_start(@game) unless @game.nil?
    end

    def basic_matchmaking
      GameQueue.transaction do
        GameQueue.with_advisory_lock('queue') do
          if GameQueue.queue_is_empty?(params[:game_type], params[:addon], current_user.id)
            GameQueue.push queue_params
          else
            @game = GameQueue.pop_and_match queue_params, current_user.id
          end
        end
      end
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
        player.send_start_signal
      end
    end
  end
end
