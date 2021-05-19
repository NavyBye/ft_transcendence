class AddIsHostToGamePlayers < ActiveRecord::Migration[6.1]
  def change
    add_column :game_players, :is_host, :boolean, default: false
  end
end
