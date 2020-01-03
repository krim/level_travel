# frozen_string_literal: true

RSpec.describe LevelTravel::Request do
  describe '.get' do
    subject(:request) { described_class.get(path, params) }

    let(:path) { '/foo/bar' }
    let(:params) { { foo: 1, bar: 10 } }

    let(:expected_response) { response.transform_keys(&:to_sym) }
    let(:api_token) { 'api_token' }
    let(:request_uri) { described_class::HOST + [path, URI.encode_www_form(params)].join('?') }
    let(:headers) do
      {
        Accept: 'application/vnd.leveltravel.v3',
        Authorization: format('Token token="%<api_token>s"', api_token: api_token)
      }
    end

    before do
      LevelTravel::Settings.api_token = api_token

      stub_request(:get, request_uri).with(headers: headers).to_return(
        body: Oj.dump(response),
        status: status,
        headers: { 'content-type' => 'application/json; charset=utf-8' }
      )
    end

    context 'with successful request' do
      let(:status) { 200 }
      let(:response) { { 'foo' => 'bar' } }

      it 'returns valid result without error' do
        expect(request).to be_success
        expect(request).to have_attributes(code: 200, body: expected_response, error: nil)
      end
    end

    context 'when request fails' do
      let(:status) { 400 }
      let(:response) { { 'foo' => 'bar', 'error' => 'error_message' } }

      it 'returns valid result with error' do
        expect(request).to be_failure
        expect(request).to have_attributes(code: 400, body: expected_response, error: 'error_message')
      end
    end
  end
end
