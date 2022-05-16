# frozen_string_literal: true

require 'faraday'

module Controllers
  # This controller holds the action to transform an authorization code into
  # a usable access token that will be passed to the API.
  # @author Vincent Courtois <courtois.vincent@outlook.com>
  class Tokens < Base
    post '/' do
      connection = Faraday.new(
        url: ENV['AUTH_API'],
        params: {
          authorization_code: params['authorization_code'],
          client_id: ENV['CLIENT_ID'],
          client_secret: ENV['CLIENT_SECRET']
        }
      )
      resp = connection.post('/auth/tokens')
      halt resp.status, resp.body
    end
  end
end
