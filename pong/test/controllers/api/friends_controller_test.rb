require "test_helper"

class Api::FriendsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_friends_index_url
    assert_response :success
  end

  test "should get create" do
    get api_friends_create_url
    assert_response :success
  end

  test "should get destroy" do
    get api_friends_destroy_url
    assert_response :success
  end
end
