class Game < ApplicationRecord
  class NotPlayable < StandardError; end

  # enums
  enum game_type: {
    duel: 0,
    ladder: 1,
    ladder_tournament: 2,
    tournament: 3,
    war: 4,
    friendly: 5
  }

  # associations
  has_many :game_players, class_name: "GamePlayer", foreign_key: :game_id, inverse_of: :game, dependent: :destroy
  has_many :players, through: :game_players, source: :user

  # validations
  validates :game_type, inclusion: { in: Game.game_types.keys }

  def to_history(scores)
    Game.transaction do
      history = History.create! game_type: game_type, is_addon: addon
      game_players.each_with_index do |player, index|
        history.history_relations.create! user_id: player.user_id, score: scores[index]
      end
      destroy!
      history
    end
  end

  def send_start_signal
    game_players.each(&:send_start_signal)
  end

  def self.availability_check(params, current_user)
    self_available? current_user if GameQueue.where(target_id: current_user.id).empty?
    request_and_accept_available? current_user, params[:target_id] if %w[ladder_tournament
                                                                         friendly].include?(params[:game_type])
    war_match_available? current_user if params[:game_type] == 'war'
  end

  private_class_method def self.self_available?(current_user)
    raise NotPlayable unless current_user.status == 'online'
  end

  private_class_method def self.request_and_accept_available?(current_user, target_id)
    if target_id.nil?
      queue = GameQueue.find_by!(target_id: current_user.id)
      requested_user = User.find queue.user_id
      raise NotPlayable unless requested_user.status == 'ready'
    elsif User.find(target_id).status != 'online'
      raise NotPlayable
    end
  end

  private_class_method def self.war_match_available?(current_user)
    raise NotPlayable if current_user.guild.nil? || Game.where(game_type: 'war').exists?

    my_guild = current_user.guild
    raise NotPlayable if my_guild.war.nil? || my_guild.war.war_time != Time.zone.now.hour

    wait_user = GameQueue.where(game_type: 'war')
    raise NotPlayable if wait_user.exists? && User.find(wait_user.first.user_id).guild.id == current_user.guild.id
  end
end
