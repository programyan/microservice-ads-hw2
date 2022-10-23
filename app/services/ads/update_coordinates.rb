require_relative '../base_service'

module Ads
  class UpdateCoordinates
    prepend BaseService

    option :id
    option :lat
    option :lon

    attr_reader :ad

    def call
      @ad = Ad.with_pk(id)

      return fail!(I18n.t('ad.errors.base.not_found')) unless @ad

      @ad.lon = lon
      @ad.lat = lat

      return fail!(@ad.errors) unless @ad.save

      @ad
    end
  end
end