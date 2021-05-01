require "test_helper"

class ChatRoomsMembersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @current_user = users(:hyekim)
    sign_in @current_user
  end

  test "index" do
    chat_room = chat_rooms :chat_room1
    get api_chat_room_chat_rooms_members_path(chat_room.id), as: :json
    assert_response :ok
  end

  test "create" do
    chat_room = chat_rooms :chat_room2
    post api_chat_room_chat_rooms_members_path(chat_room.id), as: :json
    assert_response :created
  end

  test "create with password" do
    chat_room = chat_rooms :private_room
    post api_chat_room_chat_rooms_members_path(chat_room.id), params: { password: "wrong password" }, as: :json
    assert_response :bad_request
    post api_chat_room_chat_rooms_members_path(chat_room.id), params: { password: "password" }, as: :json
    assert_response :created
  end

  test "update" do
    chat_room = chat_rooms :chat_room1
    target = users(:user1)
    put api_chat_room_chat_rooms_member_path(chat_room.id, target.id),
        params: { status: 1, duration: 3, role: "admin" }, as: :json
    assert_response :ok
    assert ChatRoomsMember.find_by!(chat_room: chat_room, user: target).muted?
  end

  test "delete" do
    chat_room = chat_rooms :chat_room1
    delete api_chat_room_chat_rooms_member_path(chat_room.id, @current_user.id)
    assert_response :ok
  end
end
