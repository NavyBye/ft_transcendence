class CreateHistoryGuilds < ActiveRecord::Migration[6.1]
  def change
    create_table :history_guilds do |t|
      t.references :guild, null: false, foreign_key: { to_table: :guilds }
      t.references :war_history, null: false, foreign_key: { to_table: :war_histories }
      t.index %i[guild_id war_history_id], unique: true
      t.integer :result, null: false, default: 0
      t.timestamps
    end
  end
end
