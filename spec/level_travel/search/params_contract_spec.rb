# frozen_string_literal: true

RSpec.describe LevelTravel::Search::ParamsContract do
  subject(:errors) { described_class.new.call(params).errors.to_h }

  let(:start_date) { Date.today.next_month }
  let(:kids_ages) { %w[3 5] }
  let(:stars_from) { '1' }
  let(:stars_to) { '4' }
  let(:params) do
    {
      from_city: 'Moscow',
      to_country: 'EG',
      nights: '2',
      adults: '2',
      start_date: start_date,
      to_city: 'Hurghada',
      hotel_ids: %w[123 456],
      kids: '2',
      kids_ages: kids_ages,
      stars_from: stars_from,
      stars_to: stars_to
    }
  end

  it 'validates the params' do
    expect(errors).to be_empty
  end

  context 'when some params were not provided' do
    let(:params) do
      {
        from_city: 'Moscow',
        to_country: 'EG',
        nights: '2',
        adults: '2',
        start_date: start_date
      }
    end

    it 'validates the params' do
      expect(errors).to be_empty
    end
  end

  describe 'start_date' do
    context 'when start_date is not in the future' do
      let(:start_date) { Date.today }

      it 'returns an error' do
        expect(errors[:start_date]).to contain_exactly('must be in the future')
      end
    end
  end

  describe 'kids_ages' do
    context 'when its empty' do
      let(:kids_ages) { [] }

      it 'returns an error' do
        expect(errors[:kids_ages]).to contain_exactly('is required')
      end
    end

    context 'when its above than maximum' do
      let(:kids_ages) { %w[10 15] }

      it 'returns an error' do
        expect(errors[:kids_ages]).to contain_exactly('must be in range of 0..12')
      end
    end

    context 'when its count not equal to kids count' do
      let(:kids_ages) { %w[1] }

      it 'returns an error' do
        expect(errors[:kids_ages]).to contain_exactly('number of kids_ages is not equal to kids 1 != 2')
      end
    end
  end

  describe 'stars_from' do
    context 'when its not in range' do
      let(:stars_from) { '6' }

      it 'returns an error' do
        expect(errors[:stars_from]).to contain_exactly('must be in range of 1..5')
      end
    end
  end

  describe 'stars_to' do
    context 'when its not in range' do
      let(:stars_to) { '6' }

      it 'returns an error' do
        expect(errors[:stars_to]).to contain_exactly('must be in range of 1..5')
      end
    end
  end
end
