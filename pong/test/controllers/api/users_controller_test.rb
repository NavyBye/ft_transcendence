require "test_helper"
require "json"

module Api
  class UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test 'users index' do
      login :hyeyoo
      get '/api/users'
      assert_response :success
    end

    test 'users index without login' do
      get '/api/users'
      assert_response :unauthorized
    end

    test 'user show' do
      login :hyeyoo
      get "/api/users/#{@user.id}"
      assert_response :success
    end

    test 'user show not found' do
      login :hyeyoo
      get '/api/users/0'
      assert_response :missing
    end

    test 'user show without login' do
      get '/api/users/1'
      assert_response :unauthorized
    end

    test 'user update' do
      login :hyeyoo
      assert_changes '@user.reload.nickname' do
        put api_user_path(@user.id), params: { nickname: 'new_nickname' }
      end
      result = JSON.parse @response.body
      assert_equal result['nickname'], 'new_nickname'
    end

    test 'user image update' do
      login :user_without_image
      assert_changes '@user.reload.image' do
        file_dir = Rails.root.join('test/fixtures/files/')
        File.open(file_dir.join('rails_logo.png')) do |image_file|
          put api_user_path(@user.id), params: { image: image_file }
        end
        assert_response :ok
      end
    end

    private

    def login(user_symbol)
      @user = users(user_symbol)
      sign_in @user
    end
  end
end
