require "test_helper"

module Api
  class FriendsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test "should get index" do
      login :hyeyoo
      get api_user_friends_url(@user.id)
      assert_response :ok

      result.each do |friend|
        assert Friend.where(user_id: @user.id, follow_id: friend['id']).exists?
      end
    end

    test "create with right permission" do
      login :hyeyoo
      follow_user = users(:master)
      assert_difference '@user.reload.followings.count', 1 do
        post api_user_friends_url(@user.id), params: { follow_id: follow_user.id }
      end
      assert_response :created
      assert_equal result['follow_id'], follow_user.id
    end

    test "create with wrong permission" do
      login :hyeyoo
      other_user = users(:officer)
      follow_user = users(:master)
      assert_no_difference 'other_user.reload.followings.count' do
        post api_user_friends_url(other_user.id), params: { follow_id: follow_user.id }
      end
      assert_response :forbidden
    end

    test "destroy with right permission" do
      login :hyeyoo
      follow_user = users(:hyekim)
      assert_difference '@user.reload.followings.count', -1 do
        delete api_user_friend_url(@user.id, follow_user.id)
      end
      assert_response :no_content
    end

    test "destroy with wrong permission" do
      login :officer
      other_user = users(:hyeyoo)
      follow_user = users(:hyekim)
      assert_no_difference 'other_user.reload.followings.count', -1 do
        delete api_user_friend_url(other_user.id, follow_user.id)
      end
      assert_response :forbidden
    end

    private

    def login(someone)
      @user = users(someone)
      sign_in @user
    end

    def result
      @result = JSON.parse @response.body
    end
  end
end
