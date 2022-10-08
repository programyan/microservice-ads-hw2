require_relative 'api'

module GeocodeService
  class Client < BaseHttpClient
    include Api

    option :url, default: proc { ENV.fetch('GEOCODE_BASE_URL') }
    option :connection, default: proc { build_connection }
  end
end