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

  namespace :api, defaults: { format: :json } do
    post 'auth', to: 'auth#match'

    resources :users, only: %i[index show update] do
      collection do
        get 'rank'
        get 'challenge'
        get 'me'
      end
      member do
        get 'game'
        get 'histories'
        post 'designate', controller: 'admin'
        post 'ban', controller: 'admin'
      end
      resources :friends, only: %i[index create destroy], param: :id
      resources :blocks, only: %i[index create destroy], param: :id
      resources :invites, only: %i[index create update destroy]
    end

    resources :guilds, only: %i[index show create destroy] do
      collection do
        get 'rank'
        get 'my'
      end
      member do
        get 'histories'
      end
      resources :members, only: %i[index update destroy], controller: 'guild_members', param: :user_id
    end

    # matchmaking & game
    resources :games, only: %i[index create show] do
      collection do
        delete 'cancel'
      end
    end

    # (war) declaration
    resources :declearations, only: %i[index create update destroy]
    get 'wartimes', to: 'wars#timetable'
    get 'warmatch', to: 'wars#warmatch'

    resources :chat_rooms, path: 'chatrooms', only: %i[index update destroy create] do
      resources :chat_rooms_members, path: 'members', only: %i[index update destroy create] do
        post 'ban'
        post 'mute'
        post 'free'
      end
      resources :chat_room_messages, path: 'messages', only: %i[index]
    end
    resources :dm_rooms, path: 'dmrooms', only: %i[index create] do
      resources :dm_rooms_members, path: 'members', only: %i[index]
      put '/members', to: 'dm_rooms_members#update'
      resources :dm_room_messages, path: 'messages', only: %i[index]
    end
  end
end
