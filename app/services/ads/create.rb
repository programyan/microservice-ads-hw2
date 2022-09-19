require_relative '../base_service'

module Ads
  class Create
    prepend BaseService

    option :title
    option :description
    option :city
    option :user_id

    attr_reader :ad

    def call
      @ad = Ad.new(title:, description:, city:, user_id:)

      return fail!(@ad.errors) unless @ad.save
    end
  end
end