# frozen_string_literal: true

module LevelTravel
  module Search
    class ParamsContract < Dry::Validation::Contract
      STARS_RANGE = (1..5).freeze
      MAX_KID_AGE = 12

      params do
        required(:from_city).filled(:string)
        required(:to_country).value(:string)
        required(:nights).value(:integer)
        required(:adults).value(:integer)
        required(:start_date).value(:date)

        optional(:to_city).value(:string)
        optional(:hotel_ids).value(Types::ArrayOfIntegers)
        optional(:kids).value(:integer)
        optional(:kids_ages).value(Types::ArrayOfIntegers)
        optional(:stars_from).value(:integer)
        optional(:stars_to).value(:integer)
      end

      rule(:start_date) do
        key.failure('must be in the future') if value <= Date.today
      end

      rule(:stars_from) do
        key.failure("must be in range of #{STARS_RANGE}") unless STARS_RANGE.include?(value)
      end

      rule(:stars_to) do
        key.failure("must be in range of #{STARS_RANGE}") unless STARS_RANGE.include?(value)
      end

      rule(:kids_ages) do
        key.failure('kids_ages is required') if key? && values[:kids] && value.empty?
        key.failure("all kids_ages have to be below #{MAX_KID_AGE}") if value.any? { |age| age > MAX_KID_AGE }

        if value.size != values[:kids].to_i
          key.failure(
            "number of kids_ages is not equal to kids #{value.size} != #{values[:kids].to_i}"
          )
        end
      end
    end
  end
end
