# frozen_string_literal: true

RSpec.describe LevelTravel::Search::ParamsContract do
  subject(:params_contract) { described_class.new.call(params) }

  let(:params) do
    {
      from_city: 'Moscow',
      to_country: 'EG',
      nights: 2,
      adults: 2,
      start_date: Date.today.next_month,
      to_city: 'Hurghada',
      hotel_ids: [123, 456],
      kids: 2,
      kids_ages: [3, 5],
      stars_from: 1,
      stars_to: 4
    }
  end

  it 'validates the params' do
    expect(params_contract.errors).to be_empty
  end

  context 'when start_date is incorrect' do
  end

  context 'when kids_ages is incorrect' do
  end

  context 'when stars_from is incorrect' do
  end

  context 'when stars_to is incorrect' do
  end
end
