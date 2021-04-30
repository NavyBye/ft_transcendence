class CreateDmRooms < ActiveRecord::Migration[6.1]
  def change
    create_table :dm_rooms, &:timestamps
  end
end
