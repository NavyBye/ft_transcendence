module Api
  class BlocksController < ApplicationController
    before_action :authenticate_user!
    before_action :check_permission, only: %i[create destroy]

    def index
      @user = User.find(params[:user_id])
      render json: @user.blacklist, status: :ok
    end

    def create
      @new_block = Block.create(block_params)
      render json: @new_block, status: :created
    end

    def destroy
      @cancel_block = Block.find_by(block_params)
      @cancel_block.destroy!
      render json: {}, status: :no_content
    end

    private

    def block_params
      params.permit(:user_id, :blocked_user_id)
    end

    def check_permission
      is_admin = false # TODO : admin/owner check.
      raise Block::PermissionDenied if Integer(params[:user_id]) != Integer(current_user.id) && !is_admin
    end
  end
end
