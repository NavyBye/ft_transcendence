class CreateChatRoomsMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_rooms_members do |t|
      t.references :chat_room, null: false, foreign_key: { to_table: :chat_rooms, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.integer :role, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
