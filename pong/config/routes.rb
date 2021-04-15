Rails.application.routes.draw do
  namespace :api do
    get 'friends/index'
    get 'friends/create'
    get 'friends/destroy'
  end
  root 'home#index'
  get 'home/index'
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  devise_scope :user do
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session_path
  end

  namespace :api do
    resources :users, only: %i[index show update] do
      get 'rank', on: :collection
      resources :friends, only: %i[index create destroy]
    end
    resources :chat_rooms, path: 'chatrooms', only: %i[index update destroy create] do
    end
  end
end
