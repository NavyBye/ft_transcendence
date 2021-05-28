class GamePlayer < ApplicationRecord
  # associations
  belongs_to :user, class_name: "User", foreign_key: :user_id, inverse_of: :game_relation
  belongs_to :game, class_name: "Game", foreign_key: :game_id, inverse_of: :game_players

  # validations
  validates :user_id, uniqueness: true

  # methods
  def status_update(status)
    @user = User.find user_id
    @user.update!(status: status)
    FriendChannel.broadcast_to @user, { data: serialize, status: :ok }
  end

  def send_start_signal
    connect_signal = {
      type: 'connect',
      game_id: game_id,
      is_host: is_host,
      addon: game.addon
    }
    ApplicationController.helpers.send_signal(user_id, connect_signal)
  end

  private

  def serialize(user)
    user.to_json only: %i[id name nickname status]
  end
end
