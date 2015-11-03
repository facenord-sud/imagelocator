class AppNotification < ActiveRecord::Migration
  def change
    create_table :app_notifications do |t|
      t.string :class_name
      t.string :method_name
      t.string :values
      t.boolean :is_viewed, default: false
      t.belongs_to :user, index: true

      t.timestamps
    end
  end
end
