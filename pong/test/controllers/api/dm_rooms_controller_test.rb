require "test_helper"

class DmRoomsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @dm_room = dm_rooms(:dm_room1)
    @logined_user = users(:hyekim)
    sign_in @logined_user
  end

  test "dm_room list api" do
    get api_dm_rooms_path, as: :json
    assert_response :ok
  end

  test "dm_room create api" do
    post api_dm_rooms_path, params: { user_id: users(:user1).id }, as: :json
    assert_response :created

    post api_dm_rooms_path, params: { user_id: users(:user1).id }, as: :json
    assert_response :ok

    post api_dm_rooms_path, params: { user_id: @logined_user.id }, as: :json
    assert_response :bad_request
  end
end
