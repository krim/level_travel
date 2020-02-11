# LevelTravel

Wrapper for [level.travel](https://level.travel/) API v3.

[![Build Status](https://travis-ci.org/lookmytour/level_travel.svg?branch=master)](https://travis-ci.org/lookmytour/level_travel)
[![Maintainability](https://api.codeclimate.com/v1/badges/6d7aa78830602cc3f891/maintainability)](https://codeclimate.com/github/lookmytour/level_travel/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/6d7aa78830602cc3f891/test_coverage)](https://codeclimate.com/github/lookmytour/level_travel/test_coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'level_travel'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install level_travel

## Usage

### Setup
```ruby
LevelTravel::Settings.api_token = 'YOUR_API_TOKEN'
```

### References
```ruby
LevelTravel::References.departures
LevelTravel::References.destinations
LevelTravel::References.operators
LevelTravel::References.airlines
LevelTravel::References.airports
LevelTravel::References.hotel_dump
LevelTravel::References.hotel_room_dump
LevelTravel::References.hotels(hotel_ids: [], region_ids: [], csv: false)
LevelTravel::References.flights_and_nights(city_from:, country_to:, start_date:, end_date:)
```

### Search

Full list of params for search:
```ruby
{
  from_city: 'Moscow',
  to_country: 'EG',
  nights: '2',
  adults: '2',
  start_date: Date.new(2020, 1, 17),
  to_city: 'Hurghada',
  hotel_ids: %w[123 456],
  kids: '2',
  kids_ages: %w[2 5],
  stars_from: '2',
  stars_to: '4'
}
```

How to make a search request:
```ruby
search_params = {
  from_city: 'Moscow',
  to_country: 'EG',
  nights: '2',
  adults: '2',
  start_date: Date.new(2020, 1, 25)
}

params_contract = LevelTravel::Search::ParamsContract.new.call(search_params) # optional, it validates input params
params = LevelTravel::Search::Params.new(params_contract.to_h)
search_result = LevelTravel::Search::Request.enqueue(params)
request_id = search_result.body.fetch(:request_id)
status_result = LevelTravel::Search::Request.status(request_id)
status_result.body
=> {
  :success => true,
  :status => {
    :"45" => "skipped",
    :"4" => "no_results",
    :"8" => "skipped",
    :"44" => "skipped",
    :"1" => "no_results",
    :"34" => "skipped",
    :"22" => "skipped",
    :"7" => "skipped",
    :"43" => "skipped",
    :"6" => "skipped",
    :"2" => "all_filtered",
    :"37" => "skipped",
    :"70" => "no_results" 
  }
}
```
### Get grouped hotels
```ruby
LevelTravel::Search::Request.get_grouped_hotels(request_id)
# or
# Operators' IDs. Succeeded IDs from the result of status request. 
LevelTravel::Search::Request.get_grouped_hotels(request_id, operator_ids: [1,2,3]) 
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lookmytour/level_travel.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
