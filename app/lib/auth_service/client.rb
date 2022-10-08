require_relative 'api'

module AuthService
  class Client < BaseHttpClient
    include Api

    option :url, default: proc { ENV.fetch('AUTH_BASE_URL') }
    option :connection, default: proc { build_connection }
  end
end