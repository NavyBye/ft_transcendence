class CreateInvites < ActiveRecord::Migration[6.1]
  def change
    create_table :invites do |t|
      t.references :guild, null: false, foreign_key: { to_table: :guilds }
      t.references :user, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :invites, %i[guild_id user_id], unique: true
  end
end
