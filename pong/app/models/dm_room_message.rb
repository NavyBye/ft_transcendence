class DmRoomMessage < ApplicationRecord
  belongs_to :dm_room
  belongs_to :user

  validates :body, presence: true, length: { minimum: 1, maximum: 1000 }

  before_validation :strip_body, only: [:body]

  after_create :send_signal

  private

  def strip_body
    self.body = body.strip unless body.nil?
  end

  def send_signal
    dm_signal = {
      type: "notify",
      element: "dm",
      dm_room_id: dm_room_id
    }
    opponent_user_id = dm_room.dm_rooms_members.where.not(user_id: user_id).first.user_id
    ApplicationController.helpers.send_signal(opponent_user_id, dm_signal)
  end
end
