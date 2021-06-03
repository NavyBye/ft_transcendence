class ChatRoomMessage < ApplicationRecord
  belongs_to :chat_room
  belongs_to :user

  validates :body, presence: true, length: { minimum: 1, maximum: 1000 }

  before_validation :strip_body, only: [:body]

  private

  def strip_body
    self.body = body.strip unless body.nil?
  end
end
