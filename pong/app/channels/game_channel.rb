class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find params[:id]
    @host = @game.game_players.where(is_host: true).first!
    stream_for @game
    stream_for current_user
    stream_for @host if host?
    @is_spectator = @game.players.exists? current_user.id ? false : true
    current_user.status_update :game
  end

  def unsubscribed
    return if @game.nil?

    if host?
      receive_end({ scores: [0, 3], type: "end" })
    else
      receive_end({ scores: [3, 0], type: "end" })
    end
  end

  def receive(data)
    case data["type"]
    when "input"
      receive_input(data)
    when "frame"
      receive_frame(data)
    when "end"
      receive_end(data)
    end
  end

  private

  def receive_frame(data)
    GameChannel.broadcast_to @game, data
  end

  def receive_input(data)
    return if spectator?

    data["is_host"] = host?
    GameChannel.broadcast_to @host, data unless spectator?
  end

  def receive_end(data)
    return unless host?

    update_players_status :online
    case @game.game_type
    when :tournament
      end_tournament_match
    else
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

  def lose_tournament_match(player)
    tournament_participant = TournamentParticipant.find_by! user_id: player.user_id
    tournament_participant.destroy!
    GameChannel.broadcast_to player.user, { type: "end" }
  end

  def win_tournament_match(player)
    tournament_participant = TournamentParticipant.find_by! user_id: player.user_id
    tournament_participant.win
    if tournament_participant.victoryous?
      tournament_participant.victory
      GameChannel.broadcast_to player.user, { type: "end" }
    else
      GameChannel.broadcast_to player.user, { type: "continue" }
      tournament_participant.create_game if tournament_participant.opponent?
    end
  end

  def end_tournament_match
    winner = get_winner params[scores]
    loser = @game.game_players.find_by! is_host: winner.is_host
    win_tournament_match winner
    lose_tournament_match loser
    @game
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
