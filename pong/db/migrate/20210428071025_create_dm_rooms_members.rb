class CreateDmRoomsMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :dm_rooms_members do |t|
      t.references :dm_room, null: false, foreign_key: { to_table: :dm_rooms, on_delete: :cascade }
      t.references :user, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.boolean :exited, default: false
      t.index %i[user_id dm_room_id], unique: true

      t.timestamps
    end
  end
end
