# frozen_string_literal: true

RSpec.describe LevelTravel::Settings do
  describe '.api_token' do
    let(:expected_token) { 'api_token' }

    before { described_class.api_token = nil }

    it 'returns set value' do
      expect {
        described_class.api_token = expected_token
      }.to change(described_class, :api_token).from(nil).to(expected_token)
    end
  end

  describe '.timeout' do
    subject(:timeout) { described_class.timeout }

    context 'when timeout is not set' do
      it 'returns default timeout' do
        expect(timeout).to eq(described_class::DEFAULT_TIMEOUT)
      end
    end
  end
end
