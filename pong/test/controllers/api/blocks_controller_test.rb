require "test_helper"

module Api
  class BlocksControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    test "get_blacklists" do
      login :hyeyoo
      get api_user_blocks_url(@user.id)
      assert_response :ok
      result.each do |blocked_user|
        assert Block.where(user_id: @user.id, blocked_user_id: blocked_user['id']).exists?
      end
    end

    test "add block with right permission" do
      login :hyeyoo
      to_block = users(:officer)
      assert_difference '@user.reload.blacklist.count', 1 do
        post api_user_blocks_url(@user.id), params: { blocked_user_id: to_block.id }
        assert_response :created
        assert Block.where(user_id: @user.id, blocked_user_id: to_block.id).exists?
      end
    end

    test "add block with wrong permission" do
      login :master
      other_user = users(:hyeyoo)
      to_block = users(:officer)
      assert_no_difference 'other_user.reload.blacklist.count', 1 do
        post api_user_blocks_url(other_user.id), params: { blocked_user_id: to_block.id }
        assert_response :forbidden
      end
    end

    test "cancel block with right permission" do
      login :hyeyoo
      blocked = users(:member)
      assert_difference '@user.reload.blacklist.count', -1 do
        delete api_user_block_url(@user.id, blocked.id)
        assert_response :no_content
        assert_not Block.where(user_id: @user.id, blocked_user_id: blocked.id).exists?
      end
    end

    test "cancel block with wrong permission" do
      login :officer
      other_user = users(:hyeyoo)
      blocked = users(:member)
      assert_no_difference 'other_user.reload.blacklist.count', -1 do
        delete api_user_block_url(other_user.id, blocked.id)
        assert_response :forbidden
        assert Block.where(user_id: other_user.id, blocked_user_id: blocked.id).exists?
      end
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
