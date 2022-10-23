module GeocodeService
  module Api
    def geocode(id, city)
      publish({ id: id, city: city }.to_json, type: 'geocode')
    end
  end
end