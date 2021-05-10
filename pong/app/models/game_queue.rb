class GameQueue < ApplicationRecord
  # enum
  enum game_type: Game.game_types

  # validations
  validates :game_type, inclusion: { in: Game.game_types.keys }
  validates :user_id, uniqueness: true

  # methods
  def self.playable?(user)
    user.status == 'online'
  end

  def self.queue_is_empty?(game_type, addon)
    where(game_type: game_type, addon: addon).empty?
  end

  def self.push(params)
    create!(params)
    @user = User.find params[:user_id]
    @user.status_update('ready')
  end

  def self.pop_and_match(params)
    # DB update for starting game
    game = Game.create!(game_type: params[:game_type], addon: params[:addon])
    wait_queue = GameQueue.find_by(game_type: params[:game_type], addon: params[:addon])
    GamePlayer.create!(game_id: game.id, user_id: wait_queue.user_id)
    GamePlayer.create!(game_id: game.id, user_id: params[:user_id])
    wait_queue.destroy!
    game
  end
end
