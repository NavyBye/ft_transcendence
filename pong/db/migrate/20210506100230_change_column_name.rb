class ChangeColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :games, :type, :game_type
    rename_column :game_queues, :type, :game_type
  end
end
