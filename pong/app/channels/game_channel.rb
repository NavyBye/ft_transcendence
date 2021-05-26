class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find params[:id]
    @host = @game.game_players.where(is_host: true).first!
    stream_for @game
    stream_for @host if host?
    @is_spectator = if @game.players.exists? current_user.id
                      false
                    else
                      true
                    end
  end

  def unsubscribed
    return if @game.nil?

    GameChannel.broadcast_to @game, { type: "end" }
    if host?
      @game.to_history [0, 3]
    else
      @game.to_history [3, 0]
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

  def receive_frame(data)
    GameChannel.broadcast_to @game, data
  end

  def receive_input(data)
    data["is_host"] = host?
    GameChannel.broadcast_to @host, data unless spectator?
  end

  def receive_end(data)
    return unless host?

    GameChannel.broadcast_to @game, data
    @game.to_history data["scores"]
  end

  def spectator?
    @is_spectator
  end

  def host?
    current_user.id == @host.user_id
  end
end
