# frozen_string_literal: true

RSpec.describe LevelTravel::Search::Request do
  before { allow(LevelTravel::Request).to receive(:get) }

  describe '.enqueue' do
    subject(:do_request) { described_class.enqueue(search_params) }

    let(:search_params) { LevelTravel::Search::Params.new(params_contract) }
    let(:params_contract) do
      {
        from_city: 'Moscow',
        to_country: 'EG',
        nights: 2,
        adults: 2,
        start_date: Date.new(2020, 1, 17),
        to_city: 'Hurghada',
        hotel_ids: [123, 456],
        kids: 2,
        kids_ages: [2, 5],
        stars_from: 2,
        stars_to: 4
      }
    end
    let(:expected_params) do
      {
        from_city: 'Moscow',
        to_country: 'EG',
        nights: 2,
        adults: 2,
        start_date: '17.01.2020',
        to_city: 'Hurghada',
        hotel_ids: '123,456',
        kids: 2,
        kids_ages: '2,5',
        stars_from: 2,
        stars_to: 4
      }
    end

    it 'makes an enqueue request' do
      do_request

      expect(LevelTravel::Request).to have_received(:get).with('/search/enqueue', expected_params)
    end
  end

  describe '.status' do
    subject(:do_request) { described_class.status(request_id) }

    let(:request_id) { 'string_request_id' }

    it 'makes a request to get info for search request' do
      do_request

      expect(LevelTravel::Request).to have_received(:get).with('/search/status', request_id: 'string_request_id')
    end
  end

  describe '.get_grouped_hotels' do
    subject(:do_request) { described_class.get_grouped_hotels(request_id) }

    let(:request_id) { 'string_request_id' }

    context 'without operator_ids' do
      it 'makes a request to get info about hotels' do
        do_request

        expect(LevelTravel::Request).to have_received(:get).with(
          '/search/get_grouped_hotels', request_id: 'string_request_id'
        )
      end
    end

    context 'with operator_ids' do
      subject(:do_request) { described_class.get_grouped_hotels(request_id, operator_ids: operator_ids) }

      let(:operator_ids) { [1, 2, 3] }

      it 'makes a request to get info about hotels' do
        do_request

        expect(LevelTravel::Request).to have_received(:get).with(
          '/search/get_grouped_hotels',
          request_id: 'string_request_id', operator_ids: '1,2,3'
        )
      end
    end
  end

  describe '.get_hotel_offers' do
    subject(:do_request) { described_class.get_hotel_offers(request_id, hotel_id: hotel_id) }

    let(:request_id) { 'string_request_id' }
    let(:hotel_id) { 100_500 }

    context 'without operator_ids' do
      it 'makes a request to get info about hotels' do
        do_request

        expect(LevelTravel::Request).to have_received(:get).with(
          '/search/get_hotel_offers',
          request_id: 'string_request_id',
          hotel_id: 100_500,
          compact: false
        )
      end
    end

    context 'with operator_ids' do
      subject(:do_request) do
        described_class.get_hotel_offers(request_id, hotel_id: hotel_id, operator_ids: operator_ids)
      end

      let(:operator_ids) { [1, 2, 3] }

      it 'makes a request to get info about hotels' do
        do_request

        expect(LevelTravel::Request).to have_received(:get).with(
          '/search/get_hotel_offers',
          request_id: 'string_request_id',
          hotel_id: 100_500,
          operator_ids: '1,2,3',
          compact: false
        )
      end
    end
  end
end
