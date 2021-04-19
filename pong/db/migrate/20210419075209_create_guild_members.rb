class CreateGuildMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :guild_members do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :guild, null: false, foreign_key: { to_table: :guilds }

      t.timestamps
    end
  end
end
