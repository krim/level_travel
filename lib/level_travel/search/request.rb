# frozen_string_literal: true

module LevelTravel
  module Search
    class Request
      # @param search_params [LevelTravel::Search::Params] Request params for search
      def self.enqueue(search_params)
        ::LevelTravel::Request.get('/search/enqueue', search_params.to_h)
      end

      # @param request_id [String] Request ID from the `enqueue` request
      def self.status(request_id)
        ::LevelTravel::Request.get('/search/status', request_id: request_id)
      end
    end
  end
end
