require "test_helper"

class ChatRoomMessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:hyekim)
  end

  test "chatroom message" do
    chat_room = chat_rooms(:chat_room1)
    get api_chat_room_chat_room_messages_path(chat_room.id), as: :json
    assert_response :ok
    parsed_body = JSON.parse @response.body
    assert_equal chat_room.messages.page.total_pages, parsed_body["page"]
    get api_chat_room_chat_room_messages_path(chat_room.id, page: 2), as: :json
    assert_response :ok
  end

  test "chatroom message permission" do
    chat_room = chat_rooms(:chat_room2)
    get api_chat_room_chat_room_messages_path(chat_room.id), as: :json
    assert_response :forbidden
  end
end
