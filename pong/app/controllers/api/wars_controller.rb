module Api
  class WarsController < ApplicationController
    def timetable
      render json: War.timetable, status: :ok
    end

    def warmatch
      render json: {}, status: :not_implemented
    end
  end
end
