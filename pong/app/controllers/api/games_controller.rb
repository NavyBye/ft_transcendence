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
      availability_check
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

    def availability_check
      self_available?
      request_and_accept_available? if %w[ladder_tournament friendly].include(params[:game_type])
      war_match_available? if params[:game_type] == 'war'
      tournament_available? if params[:game_type] == 'tournament'
    end

    def request_and_accept_available?
      target_id = params[:target_id]

      if target_id.nil?
        queue = GameQueue.find_by(target_id: current_user.id)
        requested_user = User.find queue.user_id
        raise Game::NotPlayable unless requested_user.status == 'ready'
      elsif User.find(target_id).status != 'online'
        raise Game::NotPlayable
      end
    end

    def self_available?
      raise Game::NotPlayable unless current_user.status == 'online'
    end

    def war_match_available?
      # TODO : my guild | my guild is in war | war time | not duplicated queue
    end

    def tournament_available?
      # TODO : tournament participation is open?
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
