module AuthHelper
  UnauthorizedError = Class.new(StandardError)

  AUTH_TOKEN = %r{\ABearer (?<token>.+)\z}

  def user_id
    auth_service.auth(matched_token)

    auth_service.user_id.presence || raise(UnauthorizedError)
  end

  def auth_service
    AuthService::Client.fetch
  end

  def matched_token
    result = env['HTTP_AUTHORIZATION']&.match(AUTH_TOKEN)
    return if result.blank?

    result[:token]
  end
end
