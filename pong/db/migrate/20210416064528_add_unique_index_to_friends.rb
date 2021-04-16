class AddUniqueIndexToFriends < ActiveRecord::Migration[6.1]
  def change
    add_index :friends, [:user_id, :follow_id], unique: true
  end
end
