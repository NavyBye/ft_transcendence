module Api
  class WarsController < ApplicationController
    before_action :authenticate_user!

    def index
      @current_war = War.where(war_time: Time.zone.now.hour)
      render status: :ok
    end

    def timetable
      render json: War.timetable, status: :ok
    end

    def warmatch
      render json: {}, status: :not_implemented
    end
  end
end
