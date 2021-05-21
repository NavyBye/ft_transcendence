class CreateHistoryUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :history_users do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.references :history, null: false, foreign_key: { to_table: :histories }
      t.index %i[user_id history_id], unique: true
      t.integer :score, null: false, default: 0
      t.timestamps
    end
  end
end
