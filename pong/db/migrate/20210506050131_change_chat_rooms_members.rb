class ChangeChatRoomsMembers < ActiveRecord::Migration[6.1]
  def change
    change_table :chat_rooms_members, bulk: true do |t|
      t.datetime :ban_at
      t.datetime :mute_at
    end

    remove_column :chat_rooms_members, :status, :integer
  end
end
