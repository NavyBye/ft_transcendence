class GameQueue < ApplicationRecord
  class RequestedUserCanceled < StandardError; end

  # enum
  enum game_type: Game.game_types

  # validations
  validates :game_type, inclusion: { in: Game.game_types.keys }
  validates :user_id, uniqueness: true
  validate :cannot_game_with_myself

  # methods
  def self.playable?(user)
    user.status == 'online'
  end

  def self.queue_is_empty?(game_type, addon, cur_user_id)
    return where(game_type: game_type, addon: addon).empty? if %w[duel ladder].include?(game_type)

    where(game_type: game_type, addon: addon, target_id: cur_user_id).empty?
  end

  def self.push(params)
    if %w[ladder_tournament friendly].include?(params[:game_type]) && params[:target_id].blank?
      # you accepted the game, but requested user canceled!
      raise RequestedUserCanceled
    end

    GameQueue.create!(params)
    @user = User.find params[:user_id]
    @user.status_update('ready')
  end

  def self.pop_and_match(params, cur_user_id)
    # Queue-based games.
    game = Game.create!(game_type: params[:game_type], addon: params[:addon])
    wait_queue = if params[:game_type] == 'duel' || params[:game_type] == 'ladder'
                   GameQueue.find_by(game_type: params[:game_type], addon: params[:addon])
                 else
                   GameQueue.find_by(game_type: params[:game_type], addon: params[:addon], target_id: cur_user_id)
                 end
    GamePlayer.create!(game_id: game.id, user_id: wait_queue.user_id)
    GamePlayer.create!(game_id: game.id, user_id: params[:user_id])
    # pop
    wait_queue.destroy!
    game
  end

  private

  def cannot_game_with_myself
    errors.add(:target_id, 'you cannot play with yourself.') if user_id == target_id
  end
end
