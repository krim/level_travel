# LevelTravel

Wrapper for [level.travel](https://level.travel/) API v3.

[![Gem Version](https://badge.fury.io/rb/level_travel.svg)](https://badge.fury.io/rb/level_travel)
[![Build Status](https://travis-ci.org/lookmytour/level_travel.svg?branch=master)](https://travis-ci.org/lookmytour/level_travel)
[![Maintainability](https://api.codeclimate.com/v1/badges/6d7aa78830602cc3f891/maintainability)](https://codeclimate.com/github/lookmytour/level_travel/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/6d7aa78830602cc3f891/test_coverage)](https://codeclimate.com/github/lookmytour/level_travel/test_coverage)


## Table of Contents

* [Installation](#installation)
* [Usage](#usage)
  * [Setup](#setup)
  * [References](#references)
  * [Hot tours](#hot-tours)
  * [Search for tours](#search-for-tours)
      * [Search request](#search-request)
      * [Get hotel's offers](#get-hotels-offers)
      * [Get actual info about the offer](#get-actual-info-about-the-offer)
      * [Submit the tour to level.travel](#submit-the-tour-to-leveltravel)
  * [Development](#development)
  * [Contributing](#contributing)
  * [License](#license)
  
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

### Hot tours

Full list of hot tours params:
```ruby
{
  countries: %w[RU TR MV],
  start_date: Date.new(2020, 1, 17),
  end_date: Date.new(2020, 1, 27),
  nights: [3, 10],
  stars: [2, 5],
  adults: 2,
  pansions: %w[RO BB HB FB],
  sort_by: 'prices',
  min_price: 5_000,
  max_price: 150_000,
  per_page: 50,
  page: 1
}
```

How to make a request to get hot tours:
```ruby
hot_tours_params = {
  start_date: Date.new(2020, 1, 17),
  end_date: Date.new(2020, 1, 27),
  sort_by: 'prices'
}

params_contract = LevelTravel::HotTours::ParamsContract.new.call(hot_tours_params) # optional, it validates input params
params = LevelTravel::HotTours::Params.new(params_contract.to_h)
hot_tours_result = LevelTravel::HotTours::Get.call(params)

hot_tours_result.body[:hot_tours]
=> [{:id=>185102968,
  :link=>"/packages/185102968",
  :date=>"2020-03-24",
  :nights=>1,
  :price=>5181,
  :adults=>1,
  :region=>"Адлер",
  :country=>"Россия",
  :discount=>50,
  :transfer=>false,
  :medical_insurance=>false,
  :pansion_name=>"RO",
  :pansion_description=>"Без питания",
  :hotel=>
   {:id=>9019298,
    ...
   }
}]
```

### Search for tours

#### Search request
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

#### Get grouped hotels
```ruby
hotels = LevelTravel::Search::Request.get_grouped_hotels(request_id)

# or

# Operators' IDs. Succeeded IDs from the result of status request. 
hotels = LevelTravel::Search::Request.get_grouped_hotels(request_id, operator_ids: [1,2,3])

hotels.body
=> {:success=>true,
  :status=>
    {:"4"=>"no_results",
      :"22"=>"all_filtered",
      .....
      :"44"=>"all_filtered"},
  :go_ext_version=>"1.10.0",
  :hotels=>
    [{:hotel=>
      {:id=>9080789,
        ...
      }
    }]
}
```

#### Get hotel's offers
```ruby
hotel_id = hotels.body[:hotels][0][:hotel][:id]
hotel_offers = LevelTravel::Search::Request.get_hotel_offers(request_id, hotel_id: hotel_id)

# or

# Operators' IDs. Succeeded IDs from the result of status request. 
hotel_offers = LevelTravel::Search::Request.get_hotel_offers(request_id, hotel_id: hotel_id, operator_ids: [1,2,3])

# or

# With `compact`: Return tours without additional information if it's true.
hotel_offers = LevelTravel::Search::Request.get_hotel_offers(request_id, hotel_id: hotel_id, operator_ids: [1,2,3], compact: true)
hotel_offers.body
=> {:success=>true,
  :request_id=>"MjEzf......",
  :hotel_offers=>
   [{:version=>1,
     :id=>"45-1ec74031c91e....",
     :operator=>45,
     :net_price=>50991,
     :fuel_charge=>0,
     :price=>50991,
     :city_from=>213,
     :country_to=>210,
     :city_to=>0,
     :start_date=>"2020-02-26",
     :arrival_date=>"2020-02-26",
     :nights_count=>7,
     :region_name=>"Шарджа",
     :room_type=>"Standard",
     :pansion=>{:name=>"BB", :description=>"Завтрак", :original_name=>"BB", :id=>2},
     :staytype_description=>"2 ADL",
     :hotel_id=>9073949,
     :hotel_name=>"Royal Hotel",
     :stars=>3,
      ...
  }]
}

```

#### Get actual info about the offer
```ruby
tour_id = hotel_offers.body[:hotels][0][:hotel][:id]
offer = LevelTravel::Search::Request.actualize(request_id, tour_id: tour_id)

offer.body
=> {:success=>true,
  :actualized=>true,
  :price=>50991,
  :transfer=>true,
  :medical_insurance=>false,
  :extras=>[{:name=>"Страховка от задержки рейса", :code_name=>"bonus_insurance", :price=>0}, {:name=>"Кино в отпуск от IVI", :code_name=>"bonus_ivi", :price=>0}],
  :visa_price=>0,
  :flights=>
   [{:to=>
      {:origin=>{:city=>{:id=>213, :name=>"Москва"}, :id=>4, :name=>"Домодедово", :code=>"DME", :timezone=>"Europe/Moscow"},
       :departure=>"2020-02-26T23:35:00.000+03:00",
       :destination=>{:city=>{:id=>11498, :name=>"Абу-Даби"}, :id=>36, :name=>"Абу-Даби", :code=>"AUH", :timezone=>"Asia/Dubai"},
       :arrival=>"2020-02-27T05:55:00.000+04:00",
       :flight_no=>"EY 064",
       :business=>false,
       :direct=>true,
       :airline=>
        {:id=>19,
          ...
        }
      }
      ...
    }]
    ...
}
```

#### Submit the tour to level.travel
```ruby
offer = LevelTravel::Search::Request.get_offer(request_id, tour_id: tour_id)

offer.body
=> {  
     :success => true,
     package => {  
       :id => 798850,
       :adults_count => 2,
       :kids_count => 0,
       :start_date => "2015-08-20",
       :arrival_date => "2015-08-20",
       :nights_count => 7,
       :pansion => "AI",
       :room_type => "Стандартный номер",
       ...
       :link => "https://leveltravel.dev/packages/798850?aflt=Partner&"
      }
    ...
   }

link_to_offer = offer.body.dig(:package, :link)
link
=> "https://leveltravel.dev/packages/798850?aflt=Partner&"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lookmytour/level_travel.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
