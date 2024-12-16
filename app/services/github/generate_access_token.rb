module Github
  class GenerateAccessToken
    attr_reader :code, :user_token

    def initialize(code, user_token)
      @code = code
      @user_token = user_token
    end

    def call
      return unless user

      fetch_access_token
    end

    private

    def user
      @user ||= User.find_by(token: user_token)
    end

    def fetch_access_token
      response = request_api

      if response.code == 200 && !response.parsed_response.include?("error")
        user.update(github_credentials: string_to_json(response.parsed_response))
      else
        Rails.logger.error(response.parsed_response)
      end
    end

    def request_api
      HTTParty.post(
        "#{ENV['GITHUB_URL']}/login/oauth/access_token",
        headers: headers,
        body: body_params
      )
    end

    def headers
      {
        "Content-Type" => "application/json"
      }
    end

    def body_params
      {
        client_id: ENV["GITHUB_CLIENT_ID"],
        client_secret: ENV["GITHUB_CLIENT_SECRET"],
        code: code,
        redirect_uri: ENV["GITHUB_REDIRECT_URI"],
        state: user_token
      }.to_json
    end

    def string_to_json(string)
      result = string.split("&").each_with_object({}) do |pair, hash|
        key, value = pair.split("=")
        hash[key] = value
      end
      result.with_indifferent_access
    end
  end
end
