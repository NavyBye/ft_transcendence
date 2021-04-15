class CreateFriends < ActiveRecord::Migration[6.1]
  def change
    create_table :friends do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :follow, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
