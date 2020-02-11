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
        # TODO: return an object like { succeeded: [], failed: [] }
        ::LevelTravel::Request.get('/search/status', request_id: request_id)
      end

      # @param request_id [String] Request ID from the `enqueue` request
      # @param operator_ids [Array<Integer>] Operators' IDs. Succeeded IDs from the result of status request.
      def self.get_grouped_hotels(request_id, operator_ids: [])
        if operator_ids.any?
          ids = operator_ids.join(',')
          ::LevelTravel::Request.get('/search/get_grouped_hotels', request_id: request_id, operator_ids: ids)
        else
          ::LevelTravel::Request.get('/search/get_grouped_hotels', request_id: request_id)
        end
      end
    end
  end
end
