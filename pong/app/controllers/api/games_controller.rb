module Api
  class GamesController < ApplicationController
    before_action :authenticate_user!

    def index
      render json: Game.all, status: :ok
    end

    def show
      @game = Game.find params[:id]
      render json: @game, status: :ok
    end

    def create
      Game.availability_check(params, current_user)
      match_make
      render json: {}, status: :no_content
    end

    def cancel
      GameQueue.with_advisory_lock('queue') do
        find_queue current_user.id
        unless @queue.nil? || @queue.target_id.nil?
          match_refuse(@queue.user_id, @queue.target_id)
          send_signal(@user.id, { type: 'refuse' })
        end
        @queue&.destroy
      end
      render json: {}, status: :no_content
    end

    private

    def match_refuse(user_id, target_id)
      @target = User.find target_id
      @user = User.find user_id
      @target.status_update('online') if @target.status != 'offline'
      @user.status_update('online') if @user.status != 'offline'
    end

    def queue_params
      raise ActiveRecord::RecordNotFound if params[:game_type].nil?

      params[:addon] = false if params[:addon].nil?
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
        tournament_matchmaking and return
      else
        war_matchmaking and return
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
      render json: {}, status: :not_implemented and return
    end

    def war_matchmaking
      # TODO : War.current
      render json: {}, status: :not_implemented and return
    end

    def find_queue(id)
      @queue = if GameQueue.where(user_id: id).exists?
                 GameQueue.where(user_id: id).first
               else
                 GameQueue.where(target_id: id).first
               end
    end

    def game_start(game)
      game.game_players.each do |player|
        player.user.status_update 'game'
        player.send_start_signal
      end
    end
  end
end
