class CreateGameQueues < ActiveRecord::Migration[6.1]
  def change
    create_table :game_queues do |t|
      t.references :user, null: false, foreign_key: { to_table: :users }, index: { unique: true }
      t.integer :type, null: false, default: 0
      t.boolean :addon, null: false, default: false
      t.timestamps
    end
  end
end
