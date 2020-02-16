# frozen_string_literal: true

module LevelTravel
  module HotTours
    class Get
      # @param hot_tours_params [LevelTravel::HotTours::Params] Request params for getting hot tours
      def self.call(hot_tours_params)
        ::LevelTravel::Request.get('/hot/tours', hot_tours_params.to_h)
      end
    end
  end
end
