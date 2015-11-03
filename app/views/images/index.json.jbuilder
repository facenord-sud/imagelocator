json.array!(@images) do |image|
  json.extract! image, :id, :latitude, :longitude, :validate
  json.url image_url(image, format: :json)
end
