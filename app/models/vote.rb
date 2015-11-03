# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  latitude   :float(24)
#  longitude  :float(24)
#  validate   :string(255)      default("pending")
#  comment    :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  image_id   :integer
#

class Vote < ActiveRecord::Base
  extend Enumerize

  MATCH_DISTANCE_IN_KM = 10 # CONSTANT to define ==> should be better with 5 ?
  NRB_OF_MATCHES_NEEDED = 3 # CONSTANT to define (here: 2 matches are enough to confirm location) ==> should be 3

  # correct = there is a match
  # pending = user voted, but not sure of the location
  # unknow = the user don't know the location, don't display the image
  enumerize :validate, in: [:correct, :pending, :unknow], default: :pending

  validates :longitude, presence: true, numericality: true, if: :not_unknow?
  validates :latitude, presence: true, numericality: true, if: :not_unknow?

  validates_presence_of :user
  validates_presence_of :image

  # def create
  #   after_create :match_location
  #
  #   validates :longitude, presence: true, numericality: true, if: {validate: :unknow}
  #   validates :latitude, presence: true, numericality: true, if: {validate: :unknow}
  #
  #   validates_presence_of :user
  #   validates_presence_of :image
  # end
  #
  # def unknow_location
  #   vote = Vote.new
  #   vote.validate = :unknow
  #   vote.save
  #
  #   validates_presence_of :user
  #   validates_presence_of :image
  # end

  belongs_to :user
  belongs_to :image

  def not_unknow?
    validate == :correct or validate == :pending
  end

  def already_voted?
    Vote.where(user_id: user_id).where(image_id: image_id).any?
  end


  # algorythm that calculates distances between two coordinates, if there is a match (example: 3 in less than 5km)
  # change entry in db
  def match_location(vote)
    lat = vote.latitude
    lng = vote.longitude
    img_id = vote.image_id

    matches = [vote.id] #array containing matches
    lat_array = []
    lon_array = []
    users_voted = [user_id]

    # iterate trough all votes on the same image
    votes = Vote.where('image_id = (?) AND id <> (?)', img_id, vote.id)
    votes.each do |v|
      dist = distance_between_coords(lat, lng, v.latitude, v.longitude)
      if dist <= MATCH_DISTANCE_IN_KM
        matches.push(v.id)
        lat_array << v.latitude
        lon_array << v.longitude
        users_voted.push(v.user_id)
      end
    end
    # check nbr of matches
    if matches.length >= NRB_OF_MATCHES_NEEDED
      # there is a match, update all votes
      matches.each do |m|
        Vote.update(m, validate: :correct)
      end

      # & update image coords
      lat_lon = midpoint(lat_array, lon_array)
      Image.update(img_id, latitude: lat_lon[0], longitude: lat_lon[1], validate: true)

      UserNotifications.create!(:image_located, [img_id], Image.find(img_id).owner)

      # todo @georg give points to all contributors in the area (the users can be retrieved above in the loop 'v.user_id')
      users_voted.each do |v|
        correctVotes = Vote.where('user_id = (?) AND validate = (?) ', v,:correct).count
        incorrectVotes = Vote.where('user_id = (?) AND validate = (?) ', v, :pending).count
        if incorrectVotes<=0
          incorrectVotes = 1
        end
        #update quality_rate and points of each user that voted for this image
        user_v = User.find(v)
        user_v.quality_rate = correctVotes/incorrectVotes
        user_v.points += 2
        user_v.save
        #User.where(:id => v).update_all(:quality_rate => correctVotes/inCorrectVotes)
      end
    end

  end

  private

    def distance_between_coords(p1Lat, p1Lng, p2Lat, p2Lng)
      r = 6371 # mean radius of earth
      p1 = degToRad(p1Lat)
      p2 = degToRad(p2Lat)
      d1 = degToRad(p2Lat-p1Lat)
      d2 = degToRad(p2Lng-p1Lng)

      a = Math::sin(d1/2) * Math::sin(d1/2) + Math::cos(p1) * Math::cos(p2) * Math::sin(d2/2) * Math::sin(d2/2)
      b = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

      d = r * b;
      return d
    end

    def degToRad(d)
      raise NilCoordinateException if d.nil?
      return d * Math::PI / 180
    end

    def midpoint(lat_array, lng_array)
      [((lat_array.reduce(:+))/(lat_array.length)), ((lng_array.reduce(:+))/(lng_array.length))]
    end


end
