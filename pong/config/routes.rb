Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    resources :chat_rooms, path: 'chatrooms', only: %i[index update destroy create] do
    end
  end

  get "/", to: "hello#index"
end
