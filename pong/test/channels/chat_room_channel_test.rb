require "test_helper"

class ChatRoomChannelTest < ActionCable::Channel::TestCase
  include ActionCable::TestHelper

  setup do
    @chat_room = chat_rooms(:chat_room1)
    stub_connection(current_user: users(:hyekim))
  end

  test "subscribes and stream for room" do
    subscribe id: @chat_room.id

    assert subscription.confirmed?
    assert_has_stream_for @chat_room

    perform :receive, body: "I'm here!"
  end

  test "broadcast" do
  end
end
