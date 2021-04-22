require "test_helper"

class ChatRoomsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @chat_room = chat_rooms(:hello)
    @logined_user = users(:hyekim)
    sign_in @logined_user
  end

  test "chat_room list api" do
    get api_chat_rooms_path, as: :json
    assert_response :ok
  end

  test "chat_room create api" do
    post api_chat_rooms_path, as: :json
    assert_response :bad_request

    post api_chat_rooms_path, params: { name: "RUBY", password: "4242" }, as: :json
    assert_response :created
  end

  test "chat_room update api" do
    put api_chat_room_path(0), as: :json
    assert_response :not_found

    put api_chat_room_path(@chat_room.id), params: { name: "hello", password: "world" }, as: :json
    assert_response :ok
    assert_not ChatRoom.find(@chat_room.id).public

    put api_chat_room_path(@chat_room.id), params: { name: "hello", password: nil }, as: :json
    assert_response :ok
    assert ChatRoom.find(@chat_room.id).public
  end

  test "chat_room destroy api" do
    delete api_chat_room_path(0), as: :json
    assert_response :not_found

    delete api_chat_room_path(@chat_room.id), as: :json
    assert_response :ok
  end
end
