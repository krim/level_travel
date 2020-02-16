# frozen_string_literal: true

module LevelTravel
  module Search
    class Params < Dry::Struct
      attribute :from_city, Types::Strict::String
      attribute :to_country, Types::Strict::String
      attribute? :to_city, Types::Strict::String
      attribute? :hotel_ids, Types.Array(Types::Strict::Integer)
      attribute :nights, Types::Strict::Integer
      attribute :adults, Types::Strict::Integer
      attribute :start_date, Types::Strict::Date
      attribute? :kids, Types::Strict::Integer
      attribute? :kids_ages, Types.Array(Types::Strict::Integer)
      attribute? :stars_from, Types::Strict::Integer
      attribute? :stars_to, Types::Strict::Integer

      def to_h
        result = super.merge(start_date: start_date.strftime('%d.%m.%Y'))
        result = result.merge(hotel_ids: hotel_ids.join(',')) if result[:hotel_ids]
        result = result.merge(kids_ages: kids_ages.join(',')) if result[:kids_ages]

        result
      end
    end
  end
end
