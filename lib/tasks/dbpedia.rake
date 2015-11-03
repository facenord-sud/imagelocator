namespace :dbpedia do

  desc 'get all places from dbpedia and save it to the database'
  task fetch: :environment do
  #   places = getContinents + getCities + getCountries
  #   places.each do |a_place|
  #     Tag.find_or_create_by name: a_place
  #     puts "#{a_place} created"
  #   end
  # end
    I18n.locale = :en
    threads = []
    threads << Thread.new { save_record :getLocations, :place }
    threads << Thread.new { save_record :getCities, :city }
    threads << Thread.new { save_record :getCountries, :country_name }
    threads << Thread.new { save_record :getGeographicalArea, :geographicalArea}
    threads << Thread.new { save_record :getNaturalPlaces, :naturalPlace}
    threads << Thread.new { save_record :getSwissGeos, :swissName}
    threads << Thread.new { save_record :getSwissCantons, :name}

    threads.each {|t| t.join}
  end
end

private

def save_record(query_type, key)
  client = SPARQL::Client.new('http://dbpedia.org/sparql')
  client.query(send(query_type)).each do |item|
    Tag.find_or_create_by(name: item[key].value)
  end
end

def getCountries
  puts 'fetch countries'
  "
      PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
      PREFIX dbpprop: <http://dbpedia.org/property/>
      PREFIX dbres: <http://dbpedia.org/resource/>
      SELECT STR(?country_name) as ?country_name WHERE {
        ?country a <http://dbpedia.org/ontology/Country>.
        ?code <http://dbpedia.org/ontology/wikiPageRedirects> ?country.
        ?country rdfs:label ?country_name.
        filter regex(str(?code), '^http://dbpedia.org/resource/ISO_3166-1:[A-Z]{2}$')
      }"
end


def getNaturalPlaces
  puts 'fetch natural places'
  "
      PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
      PREFIX dbpprop: <http://dbpedia.org/property/>
      PREFIX dbres: <http://dbpedia.org/resource/>
      SELECT STR(?placeName) as ?naturalPlace WHERE {
        ?type rdfs:subClassOf dbpedia-owl:NaturalPlace.
        ?place rdf:type ?type.
        ?place rdfs:label ?placeName.
        FILTER(LANG(?placeName)='en')
      }"
end

def getGeographicalArea
  puts 'fetch geo areas'
  "
      PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
      PREFIX dbpprop: <http://dbpedia.org/property/>
      PREFIX dbres: <http://dbpedia.org/resource/>
      SELECT STR(?placeName) as ?geographicalArea WHERE {
        ?place rdf:type yago:GeographicalArea108574314.
        ?place rdfs:label ?placeName.
        FILTER(LANG(?placeName)='en')
      }"
end

def getLocations
  puts 'fetch locations'
  "
      PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
      PREFIX dbpprop: <http://dbpedia.org/property/>
      PREFIX dbres: <http://dbpedia.org/resource/>
      SELECT STR(?placeName) as ?place WHERE {
        ?place rdfs:label ?placeName.
        ?place dbpedia-owl:locatedInArea ?country.
        ?country a <http://dbpedia.org/ontology/Country>.
        ?code <http://dbpedia.org/ontology/wikiPageRedirects> ?country.
        filter regex(str(?code), '^http://dbpedia.org/resource/ISO_3166-1:[A-Z]{2}$')
        FILTER(LANG(?placeName)='en')
      }"
end

def getCities
  puts 'fetch cities'
  "
      PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
      PREFIX dbpprop: <http://dbpedia.org/property/>
      PREFIX dbres: <http://dbpedia.org/resource/>
      SELECT DISTINCT STR(?name) As $city WHERE {
        ?city rdf:type dbpedia-owl:City ;
        rdfs:label ?name.
        FILTER(LANG(?name)='en')
      }"
end

def getSwissGeos
  puts 'fetch swiss geos'
  "
    PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
    PREFIX dbpprop: <http://dbpedia.org/property/>
    PREFIX dbres: <http://dbpedia.org/resource/>
    SELECT STR(?name) as ?swissName WHERE {
      ?thing dbpedia-owl:locatedInArea <http://dbpedia.org/resource/Switzerland>.
      ?thing rdfs:label ?name.
    }"
end

def getSwissCantons
  puts 'fetch swiss cantons'
  "
      PREFIX dbpedia-owl: <http://dbpedia.org/ontology/>
      PREFIX dbpprop: <http://dbpedia.org/property/>
      PREFIX dbres: <http://dbpedia.org/resource/>
      SELECT STR(?name) as ?name WHERE{
        ?thing dcterms:subject category:Cantons_of_Switzerland.
        ?thing rdfs:label ?name.
        FILTER(LANG(?name)='en')
      }"
end

