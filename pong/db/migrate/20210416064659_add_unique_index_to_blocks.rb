class AddUniqueIndexToBlocks < ActiveRecord::Migration[6.1]
  def change
    add_index :blocks, %i[user_id blocked_user_id], unique: true
  end
end
