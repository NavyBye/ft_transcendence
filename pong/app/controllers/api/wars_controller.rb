module Api
  class WarsController < ApplicationController
    before_action :authenticate_user!

    def index
      render json: War.all, status: :ok
    end

    def timetable
      render json: War.timetable, status: :ok
    end

    def warmatch
      render json: {}, status: :not_implemented
    end
  end
end
