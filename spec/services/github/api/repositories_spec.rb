require 'rails_helper'
require 'webmock/rspec'

RSpec.describe Github::Api::Repositories, type: :service do
  let(:access_token) { "valid_token" }
  let(:username) { "octocat" }
  let(:repository_name) { "Hello-World" }
  let(:params) { { page: 1, per_page: 10 } }

  let(:service) { described_class.new(access_token) }

  let(:url) { "https://api.github.com/user/repos?page=&per_page=" }
  let(:headers) do
    {
      'Accept'=>'application/vnd.github+json',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>"Bearer #{access_token}",
      'User-Agent'=>'Ruby'
    }
  end

  describe '#fetch_all' do
    before do
      stub_request(:get, url).
         with(
           headers: headers).
         to_return(status: 200, body: '[{ "id": 1, "name": "repo1" }]', headers: {})
    end

    it 'makes a GET request to the correct URL and returns repositories' do
      response = service.fetch_all(params)

      # Verificar que WebMock haya interceptado la solicitud
      expect(WebMock).to have_requested(:get, url)
                           .with(headers: headers).once

      # Verificar la respuesta
      expect(response.code).to eq(200)
      expect(response.body).to include("repo1")
    end
  end

  describe '#fetch_single' do
    before do
      stub_request(:get, "https://api.github.com/repos/octocat/Hello-World")
        .with(headers: { 'Authorization' => "Bearer #{access_token}", 'Accept' => 'application/vnd.github+json' })
        .to_return(status: 200, body: '{ "id": 1, "name": "Hello-World" }', headers: {})
    end

    it 'makes a GET request to the correct URL and returns the repository' do
      response = service.fetch_single(username, repository_name)

      # Verificar que WebMock haya interceptado la solicitud
      expect(WebMock).to have_requested(:get, "https://api.github.com/repos/#{username}/#{repository_name}")
                           .with(headers: { 'Authorization' => "Bearer #{access_token}" }).once

      # Verificar la respuesta
      expect(response.code).to eq(200)
      expect(response.body).to include("Hello-World")
    end
  end
end
