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
    # @user = User.find user_id
    # TODO : send signal to start
  end
end
