class Block < ApplicationRecord
  class PermissionDenied < StandardError; end

  belongs_to :user, class_name: "User"
  belongs_to :blocked_user, class_name: "User"

  validate :cannot_self_block
  validates :user_id, uniqueness: { scope: :blocked_user_id }

  private

  def cannot_self_block
    errors.add(:blocked_user_id, 'you cannot block yourself.') if user_id == blocked_user_id
  end
end
