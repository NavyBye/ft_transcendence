class CreateGuildMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :guild_members do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }, index: { unique: true }
      t.references :guild, null: false, foreign_key: { to_table: :guilds }
      t.integer :role, null: false, default: 0
      t.timestamps
    end
  end
end
