class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :validate, default: false
      t.text :comment
      # imageUploader
      t.string :image

      t.timestamps

      t.belongs_to :user
    end
  end
end
