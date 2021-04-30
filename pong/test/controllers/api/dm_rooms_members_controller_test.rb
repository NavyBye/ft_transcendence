require "test_helper"

class DmRoomsMembersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @current_user = users(:hyekim)
    sign_in @current_user
  end

  test "index" do
    dm_room = dm_rooms :dm_room1
    get api_dm_room_dm_rooms_members_path(dm_room.id), as: :json
    assert_response :ok
  end

  test "update" do
    dm_room = dm_rooms :dm_room1
    put api_dm_room_dm_rooms_members_path(dm_room.id), params: { exited: true }, as: :json
    assert_response :ok
    assert_not_nil dm_room.reload

    sign_in users(:hyeyoo)
    put api_dm_room_dm_rooms_members_path(dm_room.id), params: { exited: true }, as: :json
    assert_response :ok
    assert_raises(ActiveRecord::RecordNotFound) { dm_room.reload }

    dm_room = dm_rooms :dm_room2
    put api_dm_room_dm_rooms_members_path(dm_room.id), params: { exited: true }, as: :json
    assert_response :forbidden
  end
end
