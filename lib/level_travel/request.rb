# frozen_string_literal: true

require 'faraday'
require 'oj'

module LevelTravel
  class Request
    HOST = 'https://api.level.travel'

    class Response < Dry::Struct
      attribute :code, ::LevelTravel::Types::Strict::Integer
      attribute :error, ::LevelTravel::Types::Strict::String.optional
      attribute :body, ::LevelTravel::Types::Strict::Hash

      def success?
        code == 200
      end

      def failure?
        !success?
      end
    end

    def self.get(url, params = {})
      response = request_client.get(url) do |request|
        request.params = params
        request.options.timeout = LevelTravel::Settings.timeout
      end

      body = Oj.load(response.body, symbol_keys: true, mode: :compat)
      Response.new(code: response.status, error: body[:error], body: body)
    end

    def self.headers
      {
        Accept: 'application/vnd.leveltravel.v3',
        Authorization: format('Token token="%<api_token>s"', api_token: LevelTravel::Settings.api_token)
      }
    end

    def self.request_client
      Faraday.new(url: HOST, headers: headers)
    end

    private_class_method :headers, :request_client
  end
end
