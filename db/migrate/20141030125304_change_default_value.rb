class ChangeDefaultValue < ActiveRecord::Migration
  def change
    change_column :users, :points, :integer, default: 15
  end
end
