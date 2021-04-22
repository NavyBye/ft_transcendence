Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }
  devise_scope :user do
    delete 'sign_out', to: 'users/sessions#destroy', as: :destroy_user_session_path
  end

  namespace :api do
    resources :users, only: %i[index show update] do
      collection do
        get 'rank'
        get 'challenge'
        get 'me'
      end
      member do
        get 'game'
        get 'history'
      end
      resources :friends, only: %i[index create destroy], param: :follow_id
      resources :blocks, only: %i[index create destroy], param: :blocked_user_id
    end
    resources :chat_rooms, path: 'chatrooms', only: %i[index update destroy create] do
      resources :chat_room_members, path: 'members', only: %i[index update destroy create]
      resources :chat_room_messages, path: 'messages', only: %i[index]
    end
  end
end
