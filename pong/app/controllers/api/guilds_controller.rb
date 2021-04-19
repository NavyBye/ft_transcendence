module Api
  class GuildsController < ApplicationController
    before_action :authenticate_user!
    def index
      render json: Guild.all, status: :ok
    end

    def rank
      render json: Guild.all.order(point: :desc).page(params[:page]), status: :ok
    end

    # to be fixed
    def my
      @guild = Guild.find(params[:id])
      render json: @guild, status: :ok
    end

    def show
      @guild = Guild.find(params[:id])
      render json: @guild, status: :ok
    end

    def create
      @guild = Guild.create!(name: params[:name], anagram: params[:anagram], point: 4200)
      @guild.save!
      render json: @guild, status: :created
    end

    def destroy
      @guild = Guild.find(params[:id])
      @guild.destroy
      render json: {}, status: :no_content
    end
  end
end
