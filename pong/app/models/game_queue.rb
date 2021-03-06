class GameQueue < ApplicationRecord
  class RequestedUserCanceled < StandardError; end

  # enum
  enum game_type: Game.game_types

  # validations
  validates :game_type, inclusion: { in: Game.game_types.keys }
  validates :user_id, uniqueness: { message: 'cannot play 2 or more games at the same time.' }
  validate :cannot_game_with_myself

  # methods
  def self.playable?(user)
    user.status == 'online'
  end

  def self.queue_is_empty?(game_type, addon, cur_user_id)
    return where(game_type: game_type, addon: addon).empty? if %w[duel ladder].include?(game_type)

    return where(game_type: game_type).empty? if %w[tournament war].include?(game_type)

    where(game_type: game_type, addon: addon, target_id: cur_user_id).empty?
  end

  def self.push(params)
    if %w[ladder_tournament friendly].include?(params[:game_type]) && params[:target_id].blank?
      raise RequestedUserCanceled
    end

    queue = GameQueue.create!(params)
    if %w[ladder_tournament friendly].include?(params[:game_type])
      QueueTimeoverJob.set(wait: 30).perform_later queue.id
      target_user = User.find(params[:target_id])
      send_request_signal_when_push(target_user, params)
    end
    User.find(params[:user_id]).status_update('ready')
  end

  def self.push_war(params)
    queue = GameQueue.create!(params)
    user = User.find(queue.user_id)
    QueueTimeoverJob.set(wait: user.guild.war.tta).perform_later queue.id
    opposite_guild = WarGuild.where('war_id = ? AND guild_id != ?', user.guild.war, user.guild).first!.guild
    opposite_guild.members.each do |member|
      ApplicationController.helpers.send_signal(member.id, { type: 'notify', element: 'guildwar' })
    end
    user.status_update('ready')
  end

  def self.send_request_signal_when_push(target_user, params)
    target_user.status_update('ready')
    request_signal = {
      type: 'request',
      user: { id: target_user.id, nickname: target_user.nickname },
      game: { game_type: params[:game_type], addon: (false | params[:addon]) }
    }
    ApplicationController.helpers.send_signal(target_user.id, request_signal)
  end

  def self.pop_and_match(params, cur_user_id)
    params[:addon] = addon_adjust_when_war(params, cur_user_id)
    # Queue-based games.
    game = Game.create!(game_type: params[:game_type], addon: params[:addon])
    wait_queue = queue_find_by_param(params, cur_user_id)
    GamePlayer.create!(game_id: game.id, user_id: wait_queue.user_id, is_host: true)
    GamePlayer.create!(game_id: game.id, user_id: params[:user_id], is_host: false)
    # pop
    wait_queue.destroy!
    game
  end

  private_class_method def self.addon_adjust_when_war(params, cur_user_id)
    cur_user = User.find cur_user_id
    if params[:game_type] == 'war'
      cur_user.guild.war.is_addon
    else
      params[:addon]
    end
  end

  private

  def cannot_game_with_myself
    errors.add(:target_id, 'you cannot play with yourself.') if user_id == target_id
  end

  private_class_method def self.queue_find_by_param(params, cur_user_id)
    case params[:game_type]
    when 'duel', 'ladder'
      GameQueue.find_by(game_type: params[:game_type], addon: params[:addon])
    when 'war'
      GameQueue.find_by(game_type: params[:game_type])
    else
      GameQueue.find_by(game_type: params[:game_type], addon: params[:addon], target_id: cur_user_id)
    end
  end
end
