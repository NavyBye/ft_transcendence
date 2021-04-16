class Friend < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :follow, class_name: "User"

  validate :cannot_self_follow

  private

  def cannot_self_follow
    if user_id == follow_id
      errors.add(:follow_id, 'you cannot follow yourself.')
    end
  end
end
