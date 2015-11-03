class VotesController < ApplicationController
  before_action :authenticate_user!

  # GET /votes/new
  def new
    # @hash = Gmaps4rails.build_markers(@vote) do |vote, marker|
    #   marker.lat vote.latitude
    #   marker.lng vote.longitude
    #   marker.json({:id => vote.id })
    #   # marker.picture({
    #   #                   "url" => "/logo.png",
    #   #                   "width" =>  32,
    #   #                   "height" => 32})
    #   #marker.infowindow render_to_string(:partial => "/users/my_template", :locals => { :object => user})
    # end
    image = Image.find(params[:image_id])
   redirect_to :back, notice: t('notifications.no_rights_to_vote') if(image.owner == current_user)
    @vote = Vote.new(image: image)
    @vote.latitude = 0;
    @vote.longitude = 0;
    @new_vote = true;
  end

  def edit
    @vote = Vote.where(image_id: params[:image_id], user_id: current_user).first
    @new_vote = false;
  end

  def update
    @vote = Vote.find(params[:id])
    @vote.update(vote_params)
    begin
      @vote.match_location(@vote) # checks matches between this vote and all others for the same image
    rescue NilCoordinateException
      redirect_to :back, notice: t('votes.exceptions.nil_coordinate')
      return
    end
    if @vote.save
      redirect_to user_images_path(user_id: current_user, type: :voted), notice: t('votes.edit.notice.success')
    else
      redirect_to user_images_path(user_id: current_user, type: :voted), notice: t('votes.edit.notice.error')
    end
  end

  # POST /votes
  # POST /votes.json
  def create
    @vote = Vote.new(vote_params)
    @vote.user = current_user
    begin
      @vote.match_location(@vote) # checks matches between this vote and all others for the same image
    rescue NilCoordinateException
      redirect_to :back, notice: t('votes.exceptions.nil_coordinate')
      return
    end
    # Georg: if we vote points increase by one
    current_user.increment!(:points)
    @vote.validate = :pending
    respond_to do |format|
      if @vote.already_voted?
        format.html { redirect_to root_path, notice: t('votes.create.notice.already_voted') } # done by numa a user can only vote once... right?
      elsif @vote.save
        format.html { redirect_to root_path, notice: t('votes.create.notice.success') }
        format.json { render :show, status: :created, location: @vote }
      else
        format.html { render :new }
        format.json { render json: @vote.errors, status: :unprocessable_entity }
      end
    end
  end

  # UNKNOW VOTE : the user does not know the position of the picture
  def unknow
    @vote = Vote.new(image: Image.find(params[:image_id]))
    @vote.user = current_user
    @vote.validate = :unknow # DONE by numa: NOT SURE: is this allowed? -> YES How to access enums from Vote? -> if you enter another value as the three as expected, you have an error
    @vote.save unless @vote.already_voted? # todo: message if a user already voted no ? I don't think and shouldn't occurs
    respond_to do |format|
      format.html { redirect_to root_path, notice: t('votes.unknow.status') }
      format.json { render status: :no_content }
      format.js
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def vote_params
      params.require(:vote).permit(:latitude, :longitude, :image_id, :comment)
    end
end
