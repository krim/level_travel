# frozen_string_literal: true

RSpec.describe LevelTravel::Search do
  describe '.enqueue' do
    subject(:do_request) { described_class.enqueue(params) }

    let(:params) do
      described_class::Params.new
    end

    it 'makes an enqueue request' do
    end
  end

  describe '.status' do
    subject(:do_request) { described_class.status(request_id) }

    let(:request_id) { 1 }

    it 'makes a request to get info for search request' do
    end
  end
end
