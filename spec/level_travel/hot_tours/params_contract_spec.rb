# frozen_string_literal: true

RSpec.describe LevelTravel::HotTours::ParamsContract do
  subject(:errors) { described_class.new.call(params).errors.to_h }

  let(:countries) { %w[RU TR MV] }
  let(:start_date) { Date.today.next }
  let(:end_date) { Date.today.next_month }
  let(:kids_ages) { %w[3 5] }
  let(:stars) { %w[2 5] }
  let(:nights) { %w[3 10] }
  let(:adults) { 2 }
  let(:pansions) { %w[RO BB HB FB] }
  let(:sort_by) { 'prices' }
  let(:min_price) { 5_000 }
  let(:max_price) { 150_000 }
  let(:per_page) { 50 }
  let(:page) { 1 }
  let(:params) do
    {
      countries: countries,
      start_date: start_date,
      end_date: end_date,
      nights: nights,
      stars: stars,
      adults: adults,
      pansions: pansions,
      sort_by: sort_by,
      min_price: min_price,
      max_price: max_price,
      per_page: per_page,
      page: page
    }
  end

  it 'validates the params' do
    expect(errors).to be_empty
  end

  context 'when some params were not provided' do
    let(:params) do
      {
        start_date: start_date,
        end_date: end_date,
        sort_by: sort_by
      }
    end

    it 'validates the params' do
      expect(errors).to be_empty
    end
  end
end
