# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  latitude   :float(24)
#  longitude  :float(24)
#  validate   :boolean          default(FALSE)
#  comment    :text
#  image      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#

class Image < ActiveRecord::Base
  mount_uploader :image, ImageUploader

  validates_presence_of :image
  validates_presence_of :owner

  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :votes
  has_many :user_votes, class_name: 'User'
  has_and_belongs_to_many :tags

  scope :not_located, -> { where(validate: false).order('created_at DESC') }
  scope :located, -> { where(validate: true).order('created_at DESC') }
  scope :most_recent, -> { order('created_at DESC') }

end
