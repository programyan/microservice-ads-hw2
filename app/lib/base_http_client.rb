class BaseHttpClient
  extend Dry::Initializer[undefined: false]

  private

  def build_connection
    Faraday.new(@url) do |conn|
      conn.request :json
      conn.response :json, content_type: /\bjson$/
      conn.adapter Faraday.default_adapter
    end
  end
end
