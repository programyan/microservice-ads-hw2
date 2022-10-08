module GeocodeService
  module Api
    def geocode(city)
      response = connection.post('') do |request|
        request.body = { city: city }
      end

      response.body.dig('data') if response.success?
    end
  end
end