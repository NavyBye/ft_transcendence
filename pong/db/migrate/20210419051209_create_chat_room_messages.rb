class CreateChatRoomMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_room_messages do |t|
      t.references :chat_room, null: false, foreign_key: { to_table: :chat_rooms, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.string :body

      t.timestamps
    end
  end
end
