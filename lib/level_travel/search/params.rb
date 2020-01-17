# frozen_string_literal: true

module LevelTravel
  module Search
    class Params < Dry::Struct
      attribute :from_city, ::LevelTravel::Types::Strict::String
      attribute :to_country, ::LevelTravel::Types::Strict::String
      attribute? :to_city, ::LevelTravel::Types::Strict::String.optional
      attribute? :hotel_ids, ::LevelTravel::Types.Array(::LevelTravel::Types::Strict::Integer).optional
      attribute :nights, ::LevelTravel::Types::Strict::Integer
      attribute :adults, ::LevelTravel::Types::Strict::Integer
      attribute :start_date, ::LevelTravel::Types::Strict::Date
      attribute? :kids, ::LevelTravel::Types::Strict::Integer.optional
      attribute? :kids_ages, ::LevelTravel::Types.Array(::LevelTravel::Types::Strict::Integer).optional
      attribute? :stars_from, ::LevelTravel::Types::Strict::Integer.optional
      attribute? :stars_to, ::LevelTravel::Types::Strict::Integer.optional

      def to_h
        result = super.merge(start_date: start_date.strftime('%d.%m.%Y'))
        result = result.merge(hotel_ids: hotel_ids.join(',')) if result[:hotel_ids]
        result = result.merge(kids_ages: kids_ages.join(',')) if result[:kids_ages]

        result
      end
    end
  end
end
