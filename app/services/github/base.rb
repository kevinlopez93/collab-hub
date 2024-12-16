module Github
  class Base
    attr_reader :access_token, :base_url

    def initialize(access_token)
      @access_token = access_token
      @base_url = ENV['GITHUB_API_URL']
    end
  end
end