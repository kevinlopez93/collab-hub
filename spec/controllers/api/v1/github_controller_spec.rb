require "rails_helper"

RSpec.describe Api::V1::GithubController, type: :controller do
  let(:user) { create(:user, github_credentials: { "access_token" => "valid_token" }) }

  describe "GET #index" do
    it "returns the GitHub OAuth URL" do
      login user
      get :index

      expected_url = "#{ENV['GITHUB_URL']}/login/oauth/authorize?client_id=#{ENV['GITHUB_CLIENT_ID']}&scope=repo,user:read&state=#{user.token}&redirect_uri=#{ENV['GITHUB_REDIRECT_URI']}"

      expect(response).to have_http_status(:ok)
      expect(json["oauth_github_url"]).to eq(expected_url)
    end

    it "returns unauthorized if user is not logged in" do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET #show" do
    let(:params) { { page: 1, per_page: 10 } }
    let(:github_response) do
      [
        { id: 1, name: "repo1", full_name: "user/repo1" },
        { id: 2, name: "repo2", full_name: "user/repo2" }
      ]
    end

    before do
      stub_request(:get, "https://api.github.com/user/repos?page=&per_page=")
        .with(
          headers: {
          'Accept'=>'application/vnd.github+json',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer valid_token',
          'User-Agent'=>'Ruby'
          }
        )
        .to_return(status: 200, body: "", headers: {})
    end

    it "returns the list of repositories when successful" do
      login user
      get :show, params: params
      expect(response).to have_http_status(:ok)
    end

    it "returns unauthorized if user is not logged in" do
      get :show, params: params
      expect(response).to have_http_status(:unauthorized)
    end
  end
end