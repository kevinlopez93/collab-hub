RSpec.describe AccessTokenGeneratorJob, type: :job do
  let(:code) { "sample_code" }
  let(:user_token) { "user_sample_token" }
  let(:github_api_url) { "https://api.github.com/login/oauth/access_token" }
  let(:headers) { { 'Accept' => 'application/json' } }
  let(:body) { { "code" => code, "client_id" => ENV['GITHUB_CLIENT_ID'], "client_secret" => ENV['GITHUB_CLIENT_SECRET'] } }

  before do
    # Configuración del stub para la llamada a la API de GitHub
    stub_request(:post, github_api_url)
      .with(
        body: hash_including(body),
        headers: headers
      )
      .to_return(
        status: 200,
        body: { access_token: "mock_access_token", token_type: "bearer" }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  it "enqueues the job in the default queue" do
    expect {
      described_class.perform_later(code, user_token)
    }.to have_enqueued_job.on_queue("default")
  end

  it "calls the GitHub API to generate an access token" do
    described_class.perform_now(code, user_token)

    # Verifica que la API de GitHub fue llamada
    expect(WebMock).to have_requested(:post, github_api_url)
      .with(
        body: hash_including(body),
        headers: headers
      ).once
  end

  it "processes the response from GitHub API correctly" do
    response = Github::GenerateAccessToken.new(code, user_token).call

    expect(response).to include(
      access_token: "mock_access_token",
      token_type: "bearer"
    )
  end
end
