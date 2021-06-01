class ChangeTournamentColumnName < ActiveRecord::Migration[6.1]
  def change
    rename_column :tournaments, :is_addon, :addon
  end
end
