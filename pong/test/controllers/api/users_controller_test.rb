require "test_helper"
require "json"

module Api
  class UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test 'users index' do
      login :hyeyoo
      get api_users_url
      assert_response :success
    end

    test 'users index without login' do
      get api_users_url
      assert_response :unauthorized
    end

    test 'user show' do
      login :hyeyoo
      get api_user_url(@user.id)
      assert_response :success
    end

    test 'user show not found' do
      login :hyeyoo
      get api_user_url(0)
      assert_response :missing
    end

    test 'user show without login' do
      @user = users(:hyeyoo)
      get api_user_url(@user.id)
      assert_response :unauthorized
    end

    test 'user update' do
      login :hyeyoo
      assert_changes '@user.reload.nickname' do
        put api_user_url(@user.id), params: { nickname: 'new_nickname' }
      end
      assert_equal result['nickname'], 'new_nickname'
    end

    test 'user image update' do
      login :user_without_image
      assert_changes '@user.reload.image' do
        file_dir = Rails.root.join('test/fixtures/files/')
        File.open(file_dir.join('rails_logo.png')) do |image_file|
          put api_user_url(@user.id), params: { image: image_file }
        end
        assert_response :ok
      end
    end

    test 'api_me' do
      login :hyeyoo
      get me_api_users_url
      assert_response :ok
      assert_equal result['nickname'], @user.nickname
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
