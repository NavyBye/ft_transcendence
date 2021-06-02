class DmRoom < ApplicationRecord
  has_many :dm_rooms_members, dependent: :destroy
  has_many :members, through: :dm_rooms_members, source: :user
  has_many :messages, dependent: :destroy, class_name: "DmRoomMessage"

  def name
    "#{members.first.nickname}, #{members.second.nickname}"
  end
end
