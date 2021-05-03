require "test_helper"

class DmRoomMessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @dm_room = dm_rooms(:dm_room1)
    sign_in users(:hyekim)
  end

  test "dmroom message" do
    get api_dm_room_dm_room_messages_path(@dm_room.id), as: :json
    assert_response :ok
    parsed_body = JSON.parse @response.body
    assert_equal @dm_room.messages.page.total_pages, parsed_body["page"]
    get api_dm_room_dm_room_messages_path(@dm_room.id, page: 2), as: :json
    assert_response :ok
  end
end
