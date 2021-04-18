class AddUniqueIndexToFriends < ActiveRecord::Migration[6.1]
  def change
    add_index :friends, %i[user_id follow_id], unique: true
  end
end
