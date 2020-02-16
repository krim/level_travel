# frozen_string_literal: true

module LevelTravel
  module HotTours
    class Params < Dry::Struct
      attribute? :countries, Types::Array.of(Types::Strict::String)
      attribute :start_date, Types::Strict::Date
      attribute :end_date, Types::Strict::Date
      attribute? :nights, Types::Array.of(Types::Strict::Integer)
      attribute? :stars, Types::Array.of(Types::Strict::Integer)
      attribute? :adults, Types::Strict::Integer
      attribute? :pansions, Types::Array.of(Types::Strict::String)
      attribute :sort_by, ParamsContract::SORT_VARIANTS
      attribute? :min_price, Types::Strict::Integer
      attribute? :max_price, Types::Strict::Integer
      attribute? :per_page, Types::Strict::Integer
      attribute? :page, Types::Strict::Integer

      def to_h
        result = super.merge(
          start_date: start_date.strftime('%d.%m.%Y'),
          end_date: end_date.strftime('%d.%m.%Y')
        )

        %i[countries nights stars pansions].each do |attr|
          result = result.merge(attr => public_send(attr).join(',')) if result[attr]
        end

        result
      end
    end
  end
end
