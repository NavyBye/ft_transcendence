require "test_helper"

module Api
  class UsersControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers

    test 'users index' do
      user = users(:hyeyoo)
      sign_in user
      get '/api/users'
      assert_response :success
    end

    test 'users index without login' do
      get '/api/users'
      assert_response :redirect
    end

    test 'user show' do
      user = users(:hyeyoo)
      sign_in user
      get '/api/users/1'
      assert_response :success
    end

#    test 'user show not found' do
#      user = users(:hyeyoo)
#      sign_in user
#      get '/api/users/0'
#      assert_response :not_found
#    end

    test 'user show without login' do
      get '/api/users/1'
      assert_response :redirect
    end
  end
end
