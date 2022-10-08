require_relative '../base_service'

module Ads
  class Create
    prepend BaseService

    option :title
    option :description
    option :city
    option :user_id
    option :geocode_service, default: proc { GeocodeService::Client.new }

    attr_reader :ad

    def call
      @ad = Ad.new(title:, description:, city:, user_id:)

      return fail!(@ad.errors) unless @ad.save

      geocode_result = geocode_service.geocode(@ad.city)

      @ad.update(geocode_result) if geocode_result
    end
  end
end