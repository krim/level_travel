# frozen_string_literal: true

module LevelTravel
  module Search
    class ParamsContract < Dry::Validation::Contract
      config.messages.default_locale = :en
      config.messages.top_namespace = 'level_travel'
      config.messages.load_paths << File.expand_path('../../../../config/errors.yml', __FILE__).freeze

      RANGES = {
        stars: (1..5).freeze,
        kids_age: (0..12).freeze
      }.freeze

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
        key.failure(:invalid) if value <= Date.today
      end

      rule(:stars_from) do
        key.failure(:not_in_range, range: RANGES.fetch(:stars)) unless RANGES.fetch(:stars).include?(value)
      end

      rule(:stars_to) do
        key.failure(:not_in_range, range: RANGES.fetch(:stars)) unless RANGES.fetch(:stars).include?(value)
      end

      rule(:kids_ages) do
        key.failure(:required) if key? && values[:kids] && value.empty?

        if value.any? { |age| !RANGES.fetch(:kids_age).include?(age) }
          key.failure(:not_in_range, range: RANGES.fetch(:kids_age))
        end

        if !value.empty? && value.size != values[:kids].to_i
          key.failure(:not_equal_to_kids, actual: value.size, needed: values[:kids].to_i)
        end
      end
    end
  end
end
