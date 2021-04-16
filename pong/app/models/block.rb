class Block < ApplicationRecord
  belongs_to :user
  belongs_to :blocked_user
end
