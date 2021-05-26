module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.id
    end

    def disconnect
      player = GamePlayer.find_by user_id: current_user.id
      unless player.nil?
        if player.is_host
          player.game.to_history [3, 0]
        else
          player.game.to_history [0, 3]
        end
        GameChannel.broadcast_to @game, {type: "end"}
      end
    end

    protected

    def find_verified_user
      verified_user = env['warden'].user
      if verified_user.nil?
        reject_unauthorized_connection
      else
        verified_user
      end
    end
  end
end
