class AccessTokenGeneratorJob < ApplicationJob
  queue_as :default

  def perform(code, user_token)
    Github::GenerateAccessToken.new(code, user_token).call
  end
end