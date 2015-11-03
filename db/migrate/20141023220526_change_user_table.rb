class ChangeUserTable < ActiveRecord::Migration
  def change
    change_column :users, :points, :integer, default: 5
    add_column :users, :quality_rate, :float, :default => 1
  end
end
