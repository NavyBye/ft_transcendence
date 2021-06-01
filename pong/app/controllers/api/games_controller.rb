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
      addon_adjust
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
      current_user.status_update('online')
      render json: {}, status: :no_content
    end

    private

    def addon_adjust
      params[:addon] = if params[:game_type] == 'war'
                         false
                       elsif params[:addon].nil?
                         false
                       else
                         params[:addon]
                       end
    end

    def match_refuse(user_id, target_id)
      @target = User.find target_id
      @user = User.find user_id
      @target.status_update('online') if @target.status != 'offline'
      @user.status_update('online') if @user.status != 'offline'
    end

    def queue_params
      raise ActiveRecord::RecordNotFound if params[:game_type].nil?

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
      when 'war'
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
      # puts "NOT IMPLEMENTED YET (Tournament Matchmaking)"
    end

    def war_matchmaking
      # TODO : War.current
      GameQueue.transaction do
        GameQueue.with_advisory_lock('war_match') do
          if GameQueue.queue_is_empty? 'war', false, current_user.id
            GameQueue.push_war queue_params
          else
            @game = GameQueue.pop_and_match queue_params, current_user.id
          end
          # if not empty & guild is good, pop and match.
        end
      end
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
