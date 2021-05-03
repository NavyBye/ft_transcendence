require "test_helper"

module Api
  class AdminControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test "owner ban admin success" do
      login :owner
      target = users(:admin)
      assert_changes 'target.reload.is_banned' do
        post ban_api_user_url(target.id), params: { is_banned: true }
      end
      assert_response :success
    end

    test "owner unban admin success" do
      login :owner
      target = users(:banned_admin)
      assert_changes 'target.reload.is_banned' do
        post ban_api_user_url(target.id), params: { is_banned: false }
      end
      assert_response :success
    end

    test "admin ban user success" do
      login :admin
      target = users(:hyeyoo)
      assert_changes 'target.reload.is_banned' do
        post ban_api_user_url(target.id), params: { is_banned: true }
      end
      assert_response :success
    end

    test "owner unban user success" do
      login :owner
      target = users(:banned_user)
      assert_changes 'target.reload.is_banned' do
        post ban_api_user_url(target.id), params: { is_banned: false }
      end
      assert_response :success
    end

    test "admin unban admin fail" do
      login :admin
      target = users(:banned_admin)
      assert_no_changes 'target.reload.is_banned' do
        post ban_api_user_url(target.id), params: { is_banned: false }
      end
      assert_response :forbidden
    end

    test "admin to user success" do
      login :owner
      target = users(:admin)
      assert_changes 'target.reload.role' do
        post designate_api_user_url(target.id), params: { role: 'user' }
      end
      assert_response :success
    end

    test "user to admin success" do
      login :owner
      target = users(:hyeyoo)
      assert_changes 'target.reload.role' do
        post designate_api_user_url(target.id), params: { role: 'admin' }
      end
      assert_response :success
    end

    test "user to admin fail" do
      login :admin
      target = users(:hyeyoo)
      assert_no_changes 'target.reload.role' do
        post designate_api_user_url(target.id), params: { role: 'admin' }
      end
      assert_response :forbidden
    end

    test "admin to user fail" do
      login :admin
      target = users(:banned_admin)
      assert_no_changes 'target.reload.role' do
        post designate_api_user_url(target.id), params: { role: 'user' }
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
