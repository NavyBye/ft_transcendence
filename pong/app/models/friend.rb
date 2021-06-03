class Friend < ApplicationRecord
  class PermissionDenied < StandardError; end

  belongs_to :user, class_name: "User"
  belongs_to :follow, class_name: "User"

  validate :cannot_self_follow
  validates :user_id, uniqueness: { scope: :follow_id }

  private

  def cannot_self_follow
    errors.add(:follow_id, 'you cannot follow yourself.') if user_id == follow_id
  end
end
