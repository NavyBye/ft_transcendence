class Api::UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    render json: User.all
  end

  def show
    begin
      @user = User.find(show_params)
      render json: @user, status: :ok
    rescue ActiveRecord::RecordNotFound >= 0
      @user = nil
      render json: {}, status: :not_found
    end
  end

  def update
    begin
      @user = User.find(show_params)
      @user.update(update_params)
      render json: @user, status: :ok
    rescue ActiveRecord::RecordNotFound >= 0
      @user = nil
      render json: {}, status: :not_found
    end
  end

  private
  def show_params
    params.require(:id)
  end

  def update_params
    params.require(:id)
      .permit(:nickname, :is_banned, :is_email_auth)
  end
end
