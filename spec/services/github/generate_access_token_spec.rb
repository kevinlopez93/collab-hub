require 'rails_helper'

RSpec.describe Github::GenerateAccessToken, type: :service do
  describe '#call' do
    let(:code) { 'test_code' }
    let(:user_token) { 'user_token' }
    let(:user) { instance_double(User, token: user_token) }
    let(:github_url) { "#{ENV['GITHUB_URL']}/login/oauth/access_token" }
    let(:response_body) { "access_token=test_access_token&scope=repo&token_type=bearer" }
    let(:headers) do
      {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/json',
        'User-Agent'=>'Ruby'
      }
    end

    subject { described_class.new(code, user_token) }

    before do
      allow(User).to receive(:find_by).with(token: user_token).and_return(user)
      allow(user).to receive(:update)
    end

    context 'when the user exists and the API responds successfully' do
      before do
        stub_request(:post, github_url)
          .with(
            headers: headers,
            body: {
              client_id: ENV["GITHUB_CLIENT_ID"],
              client_secret: ENV["GITHUB_CLIENT_SECRET"],
              code: code,
              redirect_uri: ENV["GITHUB_REDIRECT_URI"],
              state: user_token
            }.to_json
          )
          .to_return(status: 200, body: response_body, headers: headers)
      end

      it 'fetches and updates the user\'s GitHub credentials' do
        subject.call

        expect(WebMock).to have_requested(:post, github_url).with(
          headers: headers,
          body: {
            client_id: ENV["GITHUB_CLIENT_ID"],
            client_secret: ENV["GITHUB_CLIENT_SECRET"],
            code: code,
            redirect_uri: ENV["GITHUB_REDIRECT_URI"],
            state: user_token
          }.to_json
        )
        expect(user).to have_received(:update).with(
          github_credentials: hash_including(
            "access_token" => "test_access_token",
            "scope" => "repo",
            "token_type" => "bearer"
          )
        )
      end
    end

    context 'when the user does not exist' do
      before do
        allow(User).to receive(:find_by).with(token: user_token).and_return(nil)
      end

      it 'does not make any API requests' do
        subject.call

        expect(WebMock).not_to have_requested(:post, github_url)
        expect(user).not_to have_received(:update)
      end
    end

    context 'when the API returns an error' do
      before do
        stub_request(:post, github_url)
          .to_return(status: 400, body: "error=invalid_code", headers: headers)
        allow(Rails.logger).to receive(:error)
      end

      it 'logs the error and does not update the user' do
        subject.call

        expect(WebMock).to have_requested(:post, github_url)
        expect(Rails.logger).to have_received(:error).with("error=invalid_code")
        expect(user).not_to have_received(:update)
      end
    end
  end
end
