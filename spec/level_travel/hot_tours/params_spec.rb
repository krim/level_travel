# frozen_string_literal: true

RSpec.describe LevelTravel::HotTours::Params do
  describe '#to_h' do
    subject(:prepared_params) { described_class.new(params).to_h }

    let(:params) { LevelTravel::HotTours::ParamsContract.new.call(search_params).to_h }
    let(:search_params) do
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

    it 'transforms params correctly' do
      expect(prepared_params).to eq(expected_params)
    end

    context 'when some params were not provided' do
      let(:search_params) do
        {
          start_date: Date.new(2020, 1, 17),
          end_date: Date.new(2020, 1, 27),
          sort_by: 'prices'
        }
      end
      let(:expected_params) do
        {
          start_date: '17.01.2020',
          end_date: '27.01.2020',
          sort_by: 'prices'
        }
      end

      it 'transforms params correctly' do
        expect(prepared_params).to eq(expected_params)
      end
    end
  end
end
