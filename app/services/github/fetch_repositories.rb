module Github
  class FetchRepositories
    attr_reader :access_token, :params

    def initialize(access_token, params = {})
      @access_token = access_token
      @params = params
    end

    def call
      results = request_api

      {
        result: results.parsed_response,
        success: results.code == 200
      }
    end

    private

    def request_api
      Github::Api::Repositories.new(access_token).fetch_all(params)
    end
  end
end