module AuthService
  module Api
    def auth(token)
      publish({ token: token }.to_json, type: 'auth')
    end
  end
end