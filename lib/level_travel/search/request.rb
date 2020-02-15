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
        params = prepare_params(operator_ids: operator_ids)

        ::LevelTravel::Request.get('/search/get_grouped_hotels', request_id: request_id, **params)
      end

      # :reek:BooleanParameter
      # :reek:LongParameterList
      # @param request_id [String] Request ID from the `enqueue` request
      # @param hotel_id [Integer] Hotel ID from the `get_grouped_hotels` request
      # @param operator_ids [Array<Integer>] Operators' IDs. Succeeded IDs from the result of status request.
      # @param compact [Boolean] Return tours without additional information if it's true.
      def self.get_hotel_offers(request_id, hotel_id:, operator_ids: [], compact: false)
        params = prepare_params(operator_ids: operator_ids, compact: compact)

        ::LevelTravel::Request.get('/search/get_hotel_offers', request_id: request_id, hotel_id: hotel_id, **params)
      end

      # @param request_id [String] Request ID from the `enqueue` request
      # @param tour_id [Integer] Tour ID from the `get_hotel_offers` request
      def self.actualize(request_id, tour_id:)
        ::LevelTravel::Request.get('/search/actualize', request_id: request_id, tour_id: tour_id)
      end

      # @param operator_ids [Array<Integer>] Operators' IDs. Succeeded IDs from the result of status request.
      # @param other_params [Hash]
      def self.prepare_params(operator_ids:, **other_params)
        params = other_params
        params = params.merge(operator_ids: operator_ids.join(',')) if operator_ids.any?

        params
      end

      private_class_method :prepare_params
    end
  end
end
