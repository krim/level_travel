# frozen_string_literal: true

RSpec.describe LevelTravel::Search::Params do
  describe '#to_h' do
    subject(:prepared_params) { described_class.new(params).to_h }

    let(:params) { LevelTravel::Search::ParamsContract.new.call(search_params).to_h }
    let(:search_params) do
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

    it 'transforms params correctly' do
      expect(prepared_params).to eq(expected_params)
    end

    context 'when some params were not provided' do
      let(:search_params) do
        {
          from_city: 'Moscow',
          to_country: 'EG',
          nights: '2',
          adults: '2',
          start_date: Date.new(2020, 1, 17)
        }
      end
      let(:expected_params) do
        {
          from_city: 'Moscow',
          to_country: 'EG',
          nights: 2,
          adults: 2,
          start_date: '17.01.2020'
        }
      end

      it 'transforms params correctly' do
        expect(prepared_params).to eq(expected_params)
      end
    end
  end
end
