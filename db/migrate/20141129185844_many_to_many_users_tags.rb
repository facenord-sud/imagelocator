class ManyToManyUsersTags < ActiveRecord::Migration
  def change
    create_table :tags_users do |t|
      t.belongs_to :user
      t.belongs_to :tag
    end
  end
end
