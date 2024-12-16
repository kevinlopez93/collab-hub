module Api::V1
  class GithubController < ApplicationController

    # GET /github/authorize
    def index
      url = "#{ENV['GITHUB_URL']}/login/oauth/authorize?client_id=#{ENV['GITHUB_CLIENT_ID']}&scope=repo,user:read&state=#{current_user.token}&redirect_uri=#{ENV['GITHUB_REDIRECT_URI']}"
      render json: { oauth_github_url: url }, status: :ok
    end

    def show
      result = Github::FetchRepositories.new(current_user.github_credentials["access_token"], repositories_params).call

      if result[:success]
        render json: { repositories: result[:result] }, status: :ok
      else
        render json: { error: result[:result] }, status: :unprocessable_entity
      end
    end

    private

    def repositories_params
      params.permit(:page, :per_page, :visibility, :sort, :direction, :affiliation)
    end
  end
end