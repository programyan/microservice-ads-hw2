module AuthHelper
  UnauthorizedError = Class.new(StandardError)

  AUTH_TOKEN = %r{\ABearer (?<token>.+)\z}

  def user_id
    auth_service.auth(matched_token).presence || raise(UnauthorizedError)
  end

  def auth_service
    @auth_service ||= AuthService::Client.new
  end

  def matched_token
    result = env['HTTP_AUTHORIZATION']&.match(AUTH_TOKEN)
    return if result.blank?

    result[:token]
  end
end
