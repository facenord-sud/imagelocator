class CreateManyToManyTagsImages < ActiveRecord::Migration
  def change
    create_table :images_tags do |t|
      t.belongs_to :image
      t.belongs_to :tag
    end
  end
end
