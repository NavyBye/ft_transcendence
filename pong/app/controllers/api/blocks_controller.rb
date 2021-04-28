module Api
  class BlocksController < ApplicationController
    def index
      @user = User.find(params[:user_id])
      render json: @user.blacklist, status: :ok
    end

    def create
      @new_block = Block.create(block_params)
      render json: @new_block, status: :created
    end

    def delete
      @cancel_block = Block.find_by(block_params)
      render json: @cancel_block, status: :no_content
    end

    private

    def block_params
      params.permit(:user_id, :blocked_user_id)
    end
  end
end
