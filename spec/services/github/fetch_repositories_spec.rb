require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Github::FetchRepositories, type: :service do
  let(:access_token) { "valid_token" }
  let(:params) { { page: 1, per_page: 10 } }
  let(:service) { described_class.new(access_token, params) }
  let(:access_token) { "valid_token" }
  let(:api_url) { "https://api.github.com/user/repos?page=&per_page=" }
  let(:headers) do
    {
      'Accept'=>'application/vnd.github+json',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>"Bearer #{access_token}",
      'User-Agent'=>'Ruby'
    }
  end

  describe '#call' do
    context 'when API returns success' do
      before do
        stub_request(:get, api_url)
          .with(headers: headers)
          .to_return(status: 200, body: '[{ "id": 1, "name": "repo1" }, { "id": 2, "name": "repo2" }]', headers: {})
      end

      it 'makes a GET request to the correct URL and returns parsed repositories' do
        result = service.call

        # Verificar que WebMock haya interceptado la solicitud
        expect(WebMock).to have_requested(:get, api_url)
                             .with(headers: headers).once

        # Verificar la respuesta
        json_result = JSON.parse(result[:result])
        expect(result[:success]).to eq(true)
        expect(json_result).to be_an(Array)
        expect(json_result.first["name"]).to eq("repo1")
      end
    end

    context 'when API returns failure' do
      before do
        stub_request(:get, api_url)
          .with(headers: headers)
          .to_return(status: 500, body: '{"error": "Internal Server Error"}', headers: {})
      end

      it 'returns an error response when API fails' do
        result = service.call

        # Verificar que WebMock haya interceptado la solicitud
        expect(WebMock).to have_requested(:get, api_url)
                             .with(headers: headers).once

        # Verificar la respuesta de error
        json_result = JSON.parse(result[:result])
        expect(result[:success]).to eq(false)
        expect(json_result).to eq({ "error" => "Internal Server Error" })
      end
    end
  end
end
