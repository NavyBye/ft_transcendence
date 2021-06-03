class GameChannel < ApplicationCable::Channel
  class GameResult
    def self.result_apply(game, data)
      rating_apply(game, data) if %w[ladder ladder_tournament].include? game.game_type
      guild_point_apply(game, data)
      war_point_apply(game, data)
      rank_apply(game, data) if game.game_type == 'ladder_tournament'
    end

    def self.rating_apply(game, data)
      game.game_players.each do |player|
        my_score = player.is_host ? data["scores"][0] : data["scores"][1]
        if my_score >= 3
          player.user.rating += 42
        else
          player.user.rating -= 42
        end
        player.user.save!
      end
    end

    private_class_method def self.guild_point_apply(game, data)
      game.game_players.each do |player|
        my_score = player.is_host ? data['scores'][0] : data['scores'][1]
        player.user.guild.point += 1 if !player.user.guild.nil? && my_score >= 3
        player.user.guild.save! unless player.user.guild.nil?
      end
    end

    private_class_method def self.war_point_apply(game, data)
      game.game_players.each do |player|
        my_score = player.is_host ? data['scores'][0] : data['scores'][1]
        if my_score >= 3 && war_point_possible(game)
          player.user.guild.war_relation.war_point += 10
          player.user.guild.war_relation.save!
        end
      end
    end

    private_class_method def self.war_point_possible(game)
      return true if game.game_type == 'war'

      first = game.players.first
      second = game.players.second
      return false unless at_wars(first, second)

      war = first.guild.war
      return false if !war.is_extended || war.is_addon != game.addon

      war.id == second.guild.war.id
    end

    private_class_method def self.at_wars(first, second)
      return false if first.guild.nil? || second.guild.nil?

      return false if first.guild.war.nil? || second.guild.war.nil?

      true
    end

    private_class_method def self.rank_apply(game, data)
      game.game_players.each do |player|
        ApplicationController.helpers.send_signal player.user_id, { type: 'fetch', element: 'login' }
        my_score = player.is_host ? data['scores'][0] : data['scores'][1]
        my_rank = player.user.rank
        opposite_player = GamePlayer.where('game_id = ? AND user_id != ?', game.id, player.user.id).first!
        if my_rank > opposite_player.user.rank && my_score >= 3
          player.user.update!(rank: opposite_player.user.rank)
          opposite_player.user.update!(rank: my_rank)
        end
      end
    end

    def self.rank_change(req_id, target_id)
      req = User.find req_id
      target = User.find target_id
      if req.rank == target.rank + 1
        lower = req.rank
        req.update!(rank: target.rank)
        target.update!(rank: lower)
        true
      else
        false
      end
    end
  end
end

class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find params[:id]
    @host = @game.game_players.where(is_host: true).first!
    @is_spectator = @game.players.exists?(current_user.id) ? false : true
    stream_for @game
    stream_for current_user
    stream_for @host if host?
    stream_from "GameChannel:#{@game.id}:spectator" if spectator?
    spectator? ? current_user.status_update(:online) : current_user.status_update(:game)
  end

  def unsubscribed
    return current_user.status_update(:online) if spectator?
    return if @game.reload.nil?

    if host?
      receive_end({ "scores" => [0, 3], "type" => "end", "winner" => 2 })
    else
      receive_end({ "scores" => [3, 0], "type" => "end", "winner" => 1 })
    end
  end

  def receive(data)
    case data["type"]
    when "input"
      receive_input(data) unless spectator?
    when "frame"
      receive_frame(data) if host?
    when "end"
      receive_end(data) if host?
    end
  end

  private

  def receive_frame(data)
    GameChannel.broadcast_to @game, data
  end

  def receive_input(data)
    data["is_host"] = host?
    GameChannel.broadcast_to @host, data
  end

  def receive_end(data)
    @game.reload
    update_players_status :online
    case @game.game_type
    when "tournament"
      end_tournament_match(data)
    else
      GameResult.result_apply(@game, data)
      @game.to_history data["scores"]
      GameChannel.broadcast_to @game, data
    end
  end

  def spectator?
    @is_spectator
  end

  def host?
    current_user.id == @host.user_id
  end

  def lose_tournament_match(player, data)
    tournament_participant = TournamentParticipant.find_by! user_id: player.user_id
    tournament_participant.destroy!
    GameChannel.broadcast_to player.user, data
  end

  def win_tournament_match(player, data)
    tournament_participant = TournamentParticipant.find_by! user_id: player.user_id
    tournament_participant.win
    if tournament_participant.victoryous?
      tournament_participant.victory
      GameChannel.broadcast_to player.user, data
    else
      GameChannel.broadcast_to player.user, { type: "continue" }
      tournament_participant.create_game if tournament_participant.opponent?
    end
  end

  def end_tournament_match(data)
    winner = get_winner data["scores"]
    loser = @game.game_players.find_by! is_host: !winner.is_host
    GameResult.rating_apply @game, data
    @game.to_history data["scores"]
    ActionCable.server.broadcast "GameChannel:#{@game.id}:spectator", { type: "end" }
    lose_tournament_match loser, data
    win_tournament_match winner, data
  end

  def get_winner(scores)
    if scores[0] > scores[1]
      @host
    else
      @game.game_players.find_by! is_host: false
    end
  end

  def update_players_status(status)
    @game.players.each do |user|
      next if user.offline?

      user.status_update status
    end
  end
end
