# frozen_string_literal: true

module LevelTravel
  module HotTours
    # :reek:RepeatedConditional
    class ParamsContract < Dry::Validation::Contract
      config.messages.default_locale = :en
      config.messages.top_namespace = 'level_travel'
      config.messages.load_paths << File.expand_path('../../../config/errors.yml', __dir__).freeze

      RANGES = {
        stars: (1..5).freeze,
        nights: (0..30).freeze
      }.freeze
      PANSIONS = {
        RO: 'Без питания',
        BB: 'Завтрак',
        HB: 'Завтрак и ужин',
        FB: 'Завтрак, обед, ужин',
        AI: 'Всё включено',
        UAI: 'Ультра всё включено',
        AI24: 'Всё включено 24 часа',
        'HB+': 'Завтрак и ужин +',
        BBL: 'Континентальный завтрак (лёгкий)',
        HBL: 'Завтрак и обед',
        DNR: 'Ужин'
      }.freeze
      PANSIONS_VARIANTS = PANSIONS.keys.map(&:to_s).freeze
      SORT_VARIANTS = Types::String.enum('prices', 'dates')

      # TODO: from_city, to_country, and to_city are also possible to be an ID
      params do
        optional(:countries).value(Types::Array.of(Types::Strict::String))
        required(:start_date).value(:date)
        required(:end_date).value(:date)
        optional(:nights).value(Types::ArrayOfIntegers)
        optional(:stars).value(Types::ArrayOfIntegers)
        optional(:adults).value(:integer)
        optional(:pansions).filled(Types::Array.of(Types::Strict::String))
        required(:sort_by).filled(SORT_VARIANTS)
        optional(:min_price).filled(:integer)
        optional(:max_price).value(:integer)
        optional(:per_page).value(:integer)
        optional(:page).value(:integer)
      end

      rule(:start_date) do
        key.failure(:invalid) if value <= Date.today
      end

      rule(:end_date) do
        key.failure(:invalid) if value <= values[:start_date]
      end

      rule(:adults) do
        if key?
          key.failure(:invalid) unless value.positive?
          key.failure(:invalid) if value > 10
        end
      end

      rule(:pansions) do
        key.failure(:invalid) if key? && value.any? { |pansion| !PANSIONS_VARIANTS.include?(pansion) }
      end

      rule(:stars) do
        if key? && value.any? { |rating| !RANGES.fetch(:stars).include?(rating) }
          key.failure(:not_in_range, range: RANGES.fetch(:stars))
        end
      end

      rule(:min_price) do
        key.failure(:invalid) if key? && !value.positive?
      end

      rule(:max_price) do
        if key?
          key.failure(:invalid) unless value.positive?
          key.failure(:invalid) if value < values[:min_price]
        end
      end

      rule(:nights) do
        if key?
          key.failure(:invalid) if value.size != 2
          key.failure(:invalid) if value[0] > value[1]

          if value.any? { |nights| !RANGES.fetch(:nights).include?(nights) }
            key.failure(:not_in_range, range: RANGES.fetch(:nights))
          end
        end
      end
    end
  end
end
