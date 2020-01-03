# frozen_string_literal: true

RSpec.describe LevelTravel::References do
  let(:response) { LevelTravel::Request::Response.new(response_attributes) }
  let(:response_attributes) { { code: 200, error: nil, body: {} } }

  before { allow(LevelTravel::Request).to receive(:get).and_return(response) }

  shared_examples 'reference request' do |action, params|
    subject(:response_data) { described_class.public_send(action) }

    it 'returns correct result' do
      expect(response_data).to have_attributes(response_attributes)
      expect(LevelTravel::Request).to have_received(:get).with("/references/#{action}", params)
    end
  end

  it_behaves_like 'reference request', :departures, prioritized_count: 0
  it_behaves_like 'reference request', :destinations, {}
  it_behaves_like 'reference request', :operators, {}
  it_behaves_like 'reference request', :airlines, {}
  it_behaves_like 'reference request', :airports, {}
  it_behaves_like 'reference request', :hotel_dump, {}

  describe '.hotels' do
    subject(:hotels) { described_class.hotels }

    it_behaves_like 'reference request', :hotels, hotel_ids: [], region_ids: [], csv: false

    context 'when params are provided' do
      subject(:hotels) { described_class.hotels(**params) }

      let(:params) { { hotel_ids: [1], region_ids: [2], csv: true } }

      it 'returns correct result' do
        expect(hotels).to have_attributes(response_attributes)
        expect(LevelTravel::Request).to have_received(:get).with('/references/hotels', params)
      end
    end
  end

  describe '.flights_and_nights' do
    subject(:flights_and_nights) { described_class.flights_and_nights(**params) }

    let(:params) { { city_from: '123', country_to: '321', start_date: '01.01.2020', end_date: '01.01.2020' } }

    it 'returns correct result' do
      expect(flights_and_nights).to have_attributes(response_attributes)
      expect(LevelTravel::Request).to have_received(:get).with('/references/flights_and_nights', params)
    end
  end
end
