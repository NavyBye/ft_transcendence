module Api
  class RoomMessagesController < ApplicationController
    before_action :authenticate_user!
    before_action :find_room!
    before_action :check_permission!

    def index
      if params[:page].nil?
        last_page = @room.messages.page(0).total_pages
        render json: serialize(@room, last_page), status: :ok
      else
        render json: serialize(@room, params[:page]), status: :ok
      end
    end

    protected

    def serialize(room, page)
      {
        messages: room.messages.page(page).as_json(only: %i[id user body created_at],
                                                   include: { user: { only: %i[id nickname] } }), page: page.to_i
      }
    end
  end
end
