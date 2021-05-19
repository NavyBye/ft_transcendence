class GameChannel < ApplicationCable::Channel
  def subscribed
    @game = Game.find params[:id]
    @host = @game.game_players.where(is_host: true).first!
    stream_for @game
    stream_for @host if current_user.id == @host.user_id
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
    GameChannel.broadcast_to @host, data
  end

  def receive_end(data); end
end
