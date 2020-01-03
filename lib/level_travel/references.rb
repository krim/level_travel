# frozen_string_literal: true

module LevelTravel
  class References
    def self.departures(prioritized_count: 0)
      get('departures', prioritized_count: prioritized_count)
    end

    def self.destinations
      get('destinations')
    end

    def self.operators
      get('operators')
    end

    def self.airlines
      get('airlines')
    end

    def self.airports
      get('airports')
    end

    def self.hotel_dump
      get('hotel_dump')
    end

    def self.hotel_room_dump
      get('hotel_room_dump')
    end

    # :reek:BooleanParameter
    def self.hotels(hotel_ids: [], region_ids: [], csv: false)
      get(
        'hotels',
        hotel_ids: hotel_ids, region_ids: region_ids, csv: csv
      )
    end

    # :reek:LongParameterList
    def self.flights_and_nights(city_from:, country_to:, start_date:, end_date:)
      get(
        'flights_and_nights',
        city_from: city_from, country_to: country_to, start_date: start_date, end_date: end_date
      )
    end

    def self.get(data, params = {})
      ::LevelTravel::Request.get('/references/' + data, params)
    end

    private_class_method :get
  end
end
