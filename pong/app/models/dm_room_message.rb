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
      elements: "dm",
      dm_room_id: id
    }
    ApplicationController.helpers.send_signal(user_id, dm_signal)
  end
end
