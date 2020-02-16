# frozen_string_literal: true

RSpec.describe LevelTravel::HotTours::Get do
  describe '.get' do
    subject(:do_request) { described_class.call(hot_tours_params) }

    let(:hot_tours_params) { LevelTravel::HotTours::Params.new(params_contract) }
    let(:params_contract) do
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
    end
    let(:expected_params) do
      {
        countries: 'RU,TR,MV',
        start_date: '17.01.2020',
        end_date: '27.01.2020',
        nights: '3,10',
        stars: '2,5',
        adults: 2,
        pansions: 'RO,BB,HB,FB',
        sort_by: 'prices',
        min_price: 5_000,
        max_price: 150_000,
        per_page: 50,
        page: 1
      }
    end

    before { allow(LevelTravel::Request).to receive(:get) }

    it 'makes request to get hot tours' do
      do_request

      expect(LevelTravel::Request).to have_received(:get).with('/hot/tours', expected_params)
    end
  end
end
