
class ImagesController < ApplicationController
  before_action :set_image, only: [:show]
  before_action :authenticate_user!, only: [:new, :create, :wrong, :delete]

  # GET /images
  # GET /images.json
  def index
    # done by @numa pagination
    # done by numa infinite scroll

    unless params[:locale]
      # it takes I18n.locale from the previous example set_locale as before_filter in application controller
      redirect_to eval("root_#{I18n.locale}_path")
    end

    if current_user.nil?
      @images = Image.includes(:owner).not_located.most_recent.page(params[:page])
    else
      @images = Kaminari.paginate_array(current_user.images_to_locate).page(params[:page])
      #@images = current_user.images_to_locate
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    #debugger
    # automatically sends @image (set_image)
    #@votes = Vote.where(image_id: @image.id)
    @votes = @image.votes
    vote_location = Gmaps4rails.build_markers(@votes) do |vote, marker|
      marker.lat vote.latitude
      marker.lng vote.longitude
    end

    @image_location = []
    @image_location[0] = 1000 #leave at 1000
    @image_location[1] = 1000

    if vote_location.size > 0
      @votes_location = vote_location
      if @image.validate
        @image_location[0] = @image.latitude
        @image_location[1] = @image.longitude
      end
    end
  end

  # GET /images/new
  def new
    @image = Image.new
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(image_params)
    @image.owner = current_user
    tags = params[:image][:tag_ids]
    if tags.respond_to?(:gsub)
      tag_ids = tags.gsub(/^\[\](, )?/, '').split(',')
      tag_ids.collect! {|tag_id| tag_id.to_i}
      tag_ids.reject! {|tag_id| tag_id == 0}
      logger.debug(tag_ids.inspect)
      @image.tag_ids = tag_ids if tag_ids.any?
    end
    respond_to do |format|
      if @image.save
        format.html { redirect_to root_path, notice: t('images.create.success') }
        format.json { render :show, status: :created, location: @image }
        # Georg: if we upload an image points decrease by 4 points
        current_user.decrement!(:points, by=4)
      else
        format.html { render :new }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # delete image
  def delete
    @image = Image.find(params[:image_id])
    if @image.owner == current_user
      @image.destroy
      # on destroy recieve 4 points back
      current_user.increment!(:points,by=4)
    end
    respond_to do |format|
      format.js { render :action => "wrong" }
    end
  end

  # wromg location of image
  def wrong
    @image = Image.find(params[:image_id])
    if @image.owner == current_user
      @image.update(validate: false, latitude: nil, longitude: nil)
    end
    respond_to do |format|
      format.js { render :action => "wrong" }
    end
  end

  def update_text
    @selected = params[:selection]
    #@array = getContinents
    @returnValue = "Hello World"
    #@array = ["Continents","Countries"]
    #returnString=""
    #for val in @array
    #  returnString.concat("<option value='"+val+"'>'"+val+"'</option>")
    #end
    #@options=returnString
  end


  def getContinents
    query = "
      PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
      PREFIX dbpprop: <http://dbpedia.org/property/>
      PREFIX dbres: <http://dbpedia.org/resource/>

      SELECT STR(?continentName) AS ?continent WHERE{
         ?continent rdfs:label ?continentName.
         ?continent rdf:type dbpedia-owl:Continent.
         FILTER(LANG(?continentName)='en')
      }"

    result = {}
    returnValue = []
    stringResult = ""
    client = SPARQL::Client.new("http://dbpedia.org/sparql")
    #client.query(query).each.each_binding { |name, value| result[name] = value}
    result = client.query(query)
    sol = result.to_json
    obj = JSON.parse(sol)
    obj['results']['bindings'].each do |country|
      # do something
      countryName = (country['continent']['value'])
      returnValue<<(countryName)
    end
    return returnValue
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_image
    @image = Image.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def image_params
    params.require(:image).permit(:image)
  end

  def getCountries
    query = "
      PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
      PREFIX dbpprop: <http://dbpedia.org/property/>
      PREFIX dbres: <http://dbpedia.org/resource/>
      SELECT STR(?placeName) as ?naturalPlace WHERE {
        ?type rdfs:subClassOf dbpedia-owl:NaturalPlace.
        ?place rdf:type ?type.
        ?place rdfs:label ?placeName.
        FILTER(LANG(?placeName)='en')
      }"

    result = {}
    returnValue = []
    client = SPARQL::Client.new("http://dbpedia.org/sparql")
    #client.query(query).each.each_binding { |name, value| result[name] = value}
    result = client.query(query)
    sol = result.to_json
    #obj = JSON.parse(sol)
    #return obj['results']['bindings'][0]['continent']['value']
    #obj['results']['bindings'].each do |country|
      # do something
      #countryName = (country['country']['value'])
      #returnValue<<(countryName)
    #end
    return result
  end
  def getCities
    query = "
      PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
      PREFIX dbpprop: <http://dbpedia.org/property/>
      PREFIX dbres: <http://dbpedia.org/resource/>
      SELECT DISTINCT STR(?name) As $city WHERE {
        ?city rdf:type dbpedia-owl:City ;
        rdfs:label ?name.
        FILTER(LANG(?name)='en')
      }"

    result = {}
    returnValue = []
    client = SPARQL::Client.new("http://dbpedia.org/sparql")
    #client.query(query).each.each_binding { |name, value| result[name] = value}
    result = client.query(query)
    sol = result.to_json
    obj = JSON.parse(sol)
    obj['results']['bindings'].each do |city|
      # do something
      cityName = (city['city']['value'])
      returnValue<<(cityName)
    end
    #return obj['results']['bindings'][0]['continent']['value']
    return returnValue
  end

  def categories
    @categories = ["Continents","Countries"];
  end

  helper_method :getContinents
  helper_method :getCountries
  helper_method :getCities
end
