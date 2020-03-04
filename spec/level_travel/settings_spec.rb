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

  describe '.error_load_path' do
    subject(:set_path) { described_class.error_load_path = expected_path }

    let(:expected_path) { '/path/to/errors.yml' }

    after { described_class.error_load_path = nil }

    it 'returns set value' do
      expect { set_path }.
        to change(described_class, :error_load_path).from(described_class::DEFAULT_ERROR_LOAD_PATH).to(expected_path)
    end

    context 'when it is not set' do
      subject(:error_load_path) { described_class.error_load_path }

      it 'returns default timeout' do
        expect(error_load_path).to eq(described_class::DEFAULT_ERROR_LOAD_PATH)
      end
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
