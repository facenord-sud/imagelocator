# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  name                   :string(255)
#  points                 :integer          default(15)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  provider               :string(255)
#  uid                    :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  quality_rate           :float(24)        default(1.0)
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  validates_presence_of :name

  has_many :uploaded_images, class_name: 'Image'

  has_many :votes
  has_many :voted_images, through: :votes, source: :image
  has_many :notifications, class_name: 'AppNotification'
  has_and_belongs_to_many :tags

  # DONE by tibo
  # UPDATE by numa: added distinct to have unique images (no repetitions)
  # UPDATE by tibo: correction after some tests
  # Write this SQL query correctly to select all images the user did not voted (yes or no) or images which have no votes
  # -> the join displays only images to the user where there is no vote record, Ok since either the user has voted "correct"/"pending" OR it is "unknow" to him
  # You can test it by running the specs (rspec in the terminal or in rubymine select folder spec, right-click and choose run all specs in spec)
  # Voilà, j'crois il m'a fallu 30' j'suis vrm une piiive :-) j'espère que c'est bon!

  def images_to_locate
    images = Image.includes(:owner).distinct.
        joins('LEFT OUTER JOIN votes ON votes.image_id=images.id',  'LEFT OUTER JOIN images_tags ON images_tags.image_id=images.id').
        where('(votes.image_id IS NULL OR votes.image_id NOT IN (SELECT votes.image_id FROM votes WHERE votes.user_id IN (?))) AND images_tags.tag_id IN (SELECT tag_id FROM tags_users WHERE user_id=(?)) AND EXISTS(SELECT tag_id FROM tags_users WHERE user_id=(?)) AND EXISTS(SELECT image_id FROM images_tags WHERE image_id=images.id) AND images.validate != 1', id, id, id).
        order('created_at DESC')
    #debugger
    images

    allOthers = Image.includes(:owner).distinct.
        joins('LEFT OUTER JOIN votes ON votes.image_id=images.id',  'LEFT OUTER JOIN images_tags ON images_tags.image_id=images.id').
        where('(votes.image_id IS NULL OR votes.image_id NOT IN (SELECT votes.image_id FROM votes WHERE votes.user_id IN (?))) AND ((images_tags.tag_id != ALL (SELECT tag_id FROM tags_users WHERE user_id=(?)) AND EXISTS(SELECT tag_id FROM tags_users WHERE user_id=(?))) OR (NOT EXISTS(SELECT image_id FROM images_tags WHERE image_id=images.id))) AND images.validate != 1', id, id, id).
        order('created_at DESC')
    #debugger
    allOthers

    (images+allOthers).uniq
  end

=begin
  def images_to_locate
    sql = "
    SELECT DISTINCT `images`.* FROM `images` LEFT OUTER JOIN votes ON votes.image_id=images.id LEFT OUTER JOIN images_tags ON images_tags.image_id=images.id WHERE ((votes.image_id IS NULL OR votes.image_id NOT IN (SELECT votes.image_id FROM votes WHERE votes.user_id IN (3))) AND images_tags.tag_id IN (SELECT tag_id FROM tags_users WHERE user_id=(3)))  ORDER BY created_at DESC
    "
    var = Image.includes(:owner).distinct.find_by_sql(sql)
    #debugger
    var

    var = Image.includes(:owner).distinct.
    joins('LEFT OUTER JOIN votes ON votes.image_id=images.id',  "LEFT OUTER JOIN tags_users ON tags_users.user_id=#{id}").
    where('(votes.image_id IS NULL OR votes.image_id NOT IN (SELECT votes.image_id FROM votes WHERE votes.user_id IN (?))) AND tags_users.tag_id IN (SELECT image_id FROM images_tags WHERE image_id=images.id)', id).
    order('created_at DESC')
    debugger
    var

    Image.includes(:owner).distinct.
        joins('LEFT OUTER JOIN votes ON votes.image_id=images.id').
        where('(votes.image_id IS NULL OR votes.image_id NOT IN (SELECT votes.image_id FROM votes WHERE votes.user_id IN (?)))', id).
        order('created_at DESC')

    #images with tags
    images = Image.includes(:owner).distinct.
        joins('LEFT OUTER JOIN votes ON votes.image_id=images.id',  'LEFT OUTER JOIN images_tags ON images_tags.image_id=images.id').
        where('(votes.image_id IS NULL OR votes.image_id NOT IN (SELECT votes.image_id FROM votes WHERE votes.user_id IN (?))) AND images_tags.tag_id IN (SELECT tag_id FROM tags_users WHERE user_id=(?))', id, id).
        order('created_at DESC')
    #debugger
    images

  end
=end

  # DONE tibo : unknown images are displayed in profile
  def unknown_images
    voted_images.where(votes: {validate: :unknow})
  end

  # DONE tibo : unknown images are displayed in profile
  def voted_images_no_unknown
    voted_images.where('votes.validate = (?) OR votes.validate = (?)', :pending, :correct)
  end

  def to_s
    name
  end

  def self.find_for_facebook_oauth(auth)
    if (user = User.find_by(email: auth.info.email))
      return user
    end
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.save!
    end
  end

  def self.find_for_google_oauth2(auth)
    if (user = User.find_by(email: auth.info.email))
      return user
    end
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.save!
    end
  end
end
