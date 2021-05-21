class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find params[:id]
    @host = @game.game_players.where(is_host: true).first!
    stream_for @game
    stream_for @host if current_user.id == @host.user_id
    @is_spectator = if @game.players.exists? current_user
                      false
                    else
                      true
                    end
  end

  def unsubscribed; end

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
    data["is_host"] = (current_user.id == @host.user_id)
    GameChannel.broadcast_to @host, data unless spectator?
  end

  def receive_end(data)
    @game.to_history data["scores"]
  end

  def spectator?
    @is_spectator
  end
end
