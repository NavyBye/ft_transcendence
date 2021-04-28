class AddUniqueIndexToChatRoomsMembers < ActiveRecord::Migration[6.1]
  def change
    add_index :chat_rooms_members, %i[user_id chat_room_id], unique: true
  end
end
