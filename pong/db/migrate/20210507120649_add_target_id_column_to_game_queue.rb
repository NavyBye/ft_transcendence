class AddTargetIdColumnToGameQueue < ActiveRecord::Migration[6.1]
  def change
    add_reference :game_queues, :target, null: true, foreign_key: { to_table: :users }
  end
end
