class Friend < ApplicationRecord
  belongs_to :user, class_name: "User"
  belongs_to :follow, class_name: "User"
end
