class UserController < ApplicationController
  # todo @numa implement the point system
  # done by numa refactor images, votes, unknow, etc to have only one method images with paramters like: ?type=unknow
  before_action :set_user, only: [:images, :votes, :unknown]
  before_action :authenticate_user!
  def show
    @user = User.find params[:id]
  end

  def images
    # done by numa pagination and infinite scroll
    # done by numa display different categories of images depending on the params display passed in GET
    @type = params[:type]
    unless is_a_action? @type
      redirect_to :back, notice: 'You cannot view this type of images'
      return
    end
    @images = send(@type).page(params[:page])

    # add votes locations
    @votes_location_by_image = Hash.new;
    @correct_location_by_image = Hash.new;
    @images.each do |image|
      @correct_location_by_image[image.id] = [1000, 1000]
      @votes = Vote.where(image_id: image.id) #, validate: :correct
      filled_votes = Vote.where('image_id = (?) AND latitude != "" AND longitude IS NOT NULL', image.id)
      # filled_votes = Vote.where(:image_id => image.id, :latitude => nil, :longitude => nil)
      if filled_votes and filled_votes.length > 0
        vote_location = Gmaps4rails.build_markers(filled_votes) do |vote, marker|
          marker.lat vote.latitude
          marker.lng vote.longitude
        end
      end
      if vote_location and vote_location.size > 0
        @votes_location_by_image[image.id] = vote_location
        if image.validate
          @correct_location_by_image[image.id] = [image.latitude, image.longitude]
        end
        set_user
      end
    end
  end

  def notifications
    @notifications = current_user.notifications.order('created_at DESC').page(params[:page])
    render 'notifications'
    @notifications.each { |n| n.is_viewed = true unless n.is_viewed?; n.save }
  end



  private

  def set_user
    @user = User.find params[:user_id]
  end

  def is_a_action?(param)
    %w{uploaded located pending voted unknown}.include? param
  end

  def uploaded
    @user.uploaded_images
  end

  def located
    uploaded.located
  end

  def pending
    uploaded.not_located
  end

  def voted
    @user.voted_images_no_unknown
  end

  def unknown
    @user.unknown_images
  end
end

