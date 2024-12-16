module Github
  module Api
    class Repositories < Base
      def fetch_all(params)
        HTTParty.get(
          "#{ENV['GITHUB_API_URL']}/user/repos#{query_params(params)}",
          headers: headers
        )
      end

      def fetch_single(username, repository_name)
        HTTParty.get(
          "#{ENV['GITHUB_API_URL']}/repos/#{username}/#{repository_name}",
          headers: headers
        )
      end

      private

      def headers
        {
          "Accept": "application/vnd.github+json",
          "Authorization": "Bearer #{access_token}"
        }
      end

      def query_params(params)
        return "" if params.empty?

        "?#{build_query_params(params)}"
      end

      def build_query_params(params)
        params.keys.map { |key, value| "#{key}=#{value}" }.join("&")
      end
    end
  end
end
