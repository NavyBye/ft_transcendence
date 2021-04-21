module Api
  class ChatRoomMessagesController < ApplicationController
    before_action :authenticate_user!

    def index
      chat_room = ChatRoom.find(params[:chat_room_id])
      if params[:page].nil?
        last_page = chat_room.messages.page(0).total_pages
        render json: serialize(chat_room, last_page), status: :ok
      else
        render json: serialize(chat_room, params[:page]), status: :ok
      end
    end

    private

    def serialize(chat_room, page)
      {
        messages: chat_room.messages.page(page).as_json(only: %i[id user body created_at],
                                                        include: { user: { only: %i[id nickname] } }), page: page.to_i
      }
    end
  end
end
