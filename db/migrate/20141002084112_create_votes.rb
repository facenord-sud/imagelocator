class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.float :latitude
      t.float :longitude
      t.string :validate, default: 'pending'
      t.text :comment

      t.timestamps

      t.belongs_to :user
      t.belongs_to :image
    end
  end
end
