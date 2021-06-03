class AddTtaToWarAndDeclaration < ActiveRecord::Migration[6.1]
  def change
    add_column :wars, :tta, :integer, default: 20
    add_column :declarations, :tta, :integer, default: 20
  end
end
